-- =============================================
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Entry Data Tindakan Terhadap Pasien
-- =============================================
CREATE PROCEDURE [dbo].[ugd_perawatUgd_entryTindakan_addTindakanDanPerawatan]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint,
	@idMasterTarif int,
	@qty int,
	@idUserEntry int,
	@TglTindakan dateTime,
	@idOperator nvarchar(250),
	@BHP nvarchar(250)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idRuangan int = (Select a.idRuangan From masterUser a Where a.idUser = @idUserEntry)
		   ,@idStatusPendaftaran nvarchar(50) = (Select idStatusPendaftaran From transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien)
		   ,@idTindakanPasien int;

	SET NOCOUNT ON;
	DECLARE @listBHPTindakan TABLE(idObatDetail int NOT NULL, jumlah Decimal(18,2) NOT NULL);

	INSERT INTO @listBHPTindakan
			   (idObatDetail
			   ,jumlah)
		 SELECT Convert(int, Left(value, CharIndex('|', value)-1)) As idObatDetail
			   ,Convert(int, Right(value, CharIndex('|', reverse(value))-1)) As jumlah
		   FROM STRING_SPLIT(@BHP, ',') a
		  WHERE value <> '';

	DECLARE @operator TABLE(idMasterKatagoriTarip int NOT NULL, idOperator int NOT NULL);

	INSERT INTO @operator
			   (idMasterKatagoriTarip
			   ,idOperator)
		 SELECT Convert(int, Left(value, CharIndex('|', value)-1)) As idMasterKatagoriTarip
			   ,Convert(int, Right(value, CharIndex('|', reverse(value))-1)) As idOperator
		   FROM STRING_SPLIT(@idOperator, ',') a
		  WHERE value <> '';

    -- Insert statements for procedure here

	IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiMasterObatDetail a INNER JOIN @listBHPTindakan b ON a.idObatDetail = b.idObatDetail
			   WHERE ISNULL(a.stok, 0) < ISNULL(b.jumlah, 0))
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Stok Item BHP Kurang' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT TOP 1 1 FROM dbo.farmasiStokOpnameDetail a INNER JOIN @listBHPTindakan b ON a.idObatDetail = b.idObatDetail
					      INNER JOIN dbo.farmasiStokOpname c ON a.idStokOpname = c.idStokOpname
			        WHERE c.idStatusStokOpname = 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Selesaikan Proses Stok Opname BHP Ruangan' AS respon, 0 AS responCode;
		END
	ELSE 
		Begin Try
			/*Transaction Begin*/
			Begin Tran;

			/*INSERT Tindakan Pasien*/
			INSERT INTO [dbo].[transaksiTindakanPasien]
					   ([idPendaftaranPasien]
					   ,[idMasterTarif]
					   ,[qty]
					   ,[idRuangan]
					   ,[idJenisBilling]
					   ,[idUserEntry]
					   ,[tglTindakan])
				 VALUES
					   (@idPendaftaranPasien
    				   ,@idMasterTarif
					   ,@qty
					   ,@idRuangan
					   ,5/*Billing IGD*/
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
				  WHERE idMasterTarip = @idMasterTarif And [status] = 1;

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
						Inner Join @listBHPTindakan b On a.idObatDetail = b.idObatDetail
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
				   Inner Join dbo.farmasiPenjualanDetail b On a.idObatDetail = b.idObatDetail
			 WHERE b.idTindakanPasien = @idTindakanPasien;

			/*Transaction Commit*/
			Commit Tran;
			Select 'Data Tindakan Berhasil Disimpan' As respon, 1 As responCode, @idTindakanPasien As idTindakanPasien;	
		End Try
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() As respon, NULL As responCode;
		End Catch
END