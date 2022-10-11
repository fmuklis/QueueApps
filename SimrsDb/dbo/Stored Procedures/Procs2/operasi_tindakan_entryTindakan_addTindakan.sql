-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Entry Data Tindakan Terhadap Pasien
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[operasi_tindakan_entryTindakan_addTindakan]
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int
	,@idMasterTarif int
	,@idUserEntry int
	,@TglTindakan dateTime
	,@idOperator nvarchar(250)
	,@BHP nvarchar(250)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idRuangan int = (Select a.idRuangan From dbo.masterUser a Where a.idUser = @idUserEntry)
		   ,@idStatusPendaftaran int
		   ,@idJenisBilling int
		   ,@idTransaksiOrderOK int
		   ,@idTindakanPasien int
		   ,@idPenjualanHeader int;

	Select @idStatusPendaftaran = a.idStatusPendaftaran, @idTransaksiOrderOK = b.idTransaksiOrderOK
		  ,@idJenisBilling = Case
								  When a.idJenisPerawatan = 1 And a.idJenisPendaftaran In(1,2)
									   Then 6/*Billing Tagihan Rawat Inap*/
								  When a.idJenisPerawatan = 2/*RaJal*/ And a.idJenisPendaftaran = 1/*Reg IGD*/
									   Then 5/*Billing Tagihan IGD*/
								  Else 1/*Billing Tagihan RaJal*/
							  End
	  From dbo.transaksiPendaftaranPasien a
		   Inner Join dbo.transaksiOrderOK b On a.idPendaftaranPasien = b.idPendaftaranPasien
	 Where a.idPendaftaranPasien = @idPendaftaranPasien;
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	DECLARE @bhpItem TABLE(idObatDetail bigint NOT NULL, jumlah Decimal(18,2) NOT NULL);

	INSERT INTO @bhpItem
			   (idObatDetail
			   ,jumlah)
		 SELECT Convert(int, Left(value, CharIndex('|', value)-1)) As idObatDetail
			   ,Convert(int, Right(value, CharIndex('|', reverse(value))-1)) As jumlah
		   FROM STRING_SPLIT(@BHP, '#') a
		  WHERE value <> '';

	DECLARE @operator TABLE(idMasterKatagoriTarip int NOT NULL, idOperator int NOT NULL);

	INSERT INTO @operator
			   (idMasterKatagoriTarip
			   ,idOperator)
		 SELECT Convert(int, Left(value, CharIndex('|', value)-1)) As idMasterKatagoriTarip
			   ,Convert(int, Right(value, CharIndex('|', reverse(value))-1)) As idOperator
		   FROM STRING_SPLIT(@idOperator, '#') a
		  WHERE value <> '';

	IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasien WHERE idPendaftaranPasien = @idPendaftaranPasien AND idStatusPendaftaran >= 98)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, '+ b.deskripsi  As respon, 0 As responCode
			  FROM dbo.transaksiPendaftaranPasien a
				   LEFT JOIN dbo.masterStatusPendaftaran b On a.idStatusPendaftaran = b.idStatusPendaftaran
			 WHERE a.idPendaftaranPasien = @idPendaftaranPasien;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			/*INSERT Tindakan Pasien*/
			INSERT INTO [dbo].[transaksiTindakanPasien]
					   ([idPendaftaranPasien]
					   ,[idTransaksiOrderOK]
					   ,[idMasterTarif]
					   ,[idRuangan]
					   ,[idJenisBilling]
					   ,[idUserEntry]
					   ,[tglTindakan])
				 VALUES
					   (@idPendaftaranPasien
					   ,@idTransaksiOrderOK
    				   ,@idMasterTarif
					   ,@idRuangan
					   ,@idJenisBilling
					   ,@idUserEntry
					   ,@TglTindakan);
			
			/*GET idTindakanPasien*/
			SET @idTindakanPasien = SCOPE_IDENTITY();

			/*INSERT Tindakan Pasien Detail*/
			INSERT INTO [dbo].[transaksiTindakanPasienDetail]
					   ([idTindakanPasien]
					   ,[idMasterKatagoriTarip]
					   ,[nilai])
				 SELECT @idTindakanPasien
					   ,idMasterKatagoriTarip
					   ,tarip
				   FROM dbo.masterTaripDetail
				  WHERE idMasterTarip = @idMasterTarif AND [status] = 1;

			/*INSERT Tindakan Pasien Operator*/
			If Exists(Select 1 From @operator)
				Begin
					INSERT INTO [dbo].[transaksiTindakanPasienOperator]
							   ([idTindakanPasien]
							   ,[idTindakanPasienDetail]
							   ,[idOperator])
						 SELECT a.idTindakanPasien
							   ,a.idTindakanPasienDetail
							   ,b.idOperator
						   FROM dbo.transaksiTindakanPasienDetail a
								Inner Join @operator b On a.idMasterKatagoriTarip = b.idMasterKatagoriTarip
						  WHERE	a.idTindakanPasien = @idTindakanPasien;
				End

			/*INSERT BHP Detail*/
			INSERT INTO [dbo].[farmasiPenjualanDetail]
						([idTindakanPasien]
						,[idObatDetail]
						,[hargaPokok]
						,[hargaJual]
						,[jumlah]
						,[ditagih])
					SELECT @idTindakanPasien
						,a.idObatDetail
						,a.hargaPokok
						,dbo.calculator_hargaJualBarangFarmasi(a.idObatDetail)
						,b.jumlah
						,dbo.verifikasi_penagihanBHP()
					FROM dbo.farmasiMasterObatDetail a
						Inner Join @bhpItem b On a.idObatDetail = b.idObatDetail
					WHERE ISNULL(b.jumlah, 0) >= 1;
						   
			/*INSERT Entry Log Penjualan*/
			INSERT INTO [dbo].[farmasiJurnalStok]
						([idObatDetail]
						,[idPenjualanDetail]
						,[stokAwal]
						,[jumlahKeluar]
						,[stokAkhir]
						,[idUserEntry])
					SELECT b.idObatDetail
						,b.idPenjualanDetail
						,a.stok
						,b.jumlah
						,a.stok - b.jumlah
						,@idUserEntry
					FROM dbo.farmasiMasterObatDetail a
						INNER JOIN dbo.farmasiPenjualanDetail b ON a.idObatDetail = b.idObatDetail
					WHERE b.idTindakanPasien = @idTindakanPasien;

			/*UPDATE Stok BHP Ruangan*/
			UPDATE a
			   SET a.stok -= IsNull(b.jumlah, 0)
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN dbo.farmasiPenjualanDetail b On a.idObatDetail = b.idObatDetail
			 WHERE b.idTindakanPasien = @idTindakanPasien;

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Data Tindakan Operasi Berhasil Disimpan' AS respon, 1 AS responCode, @idTindakanPasien AS idTindakanPasien;	
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END