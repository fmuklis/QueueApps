-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[rajal_perawatPoli_entryTindakan_editJawabanKonsul]
	-- Add the parameters for the stored procedure here
	@idTransaksiKonsul int
	,@idMasterTarif int
	,@idUserEntry int
	,@TglTindakan dateTime
	,@idOperator nvarchar(250)
	,@jawaban nvarchar(max)
	,@anjuran nvarchar(max)
	,@BHP nvarchar(250)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idPendaftaranPasien int = (Select idPendaftaranPasien From transaksiKonsul
										 Where idTransaksiKonsul = @idTransaksiKonsul)
		   ,@idRuangan int = (Select idRuangan From masterUser Where idUser = @idUserEntry)
		   ,@idTindakanPasien int;
	Declare @idJenisBilling int = Case
										When Exists(Select 1 From dbo.transaksiPendaftaranPasien 
													 Where idPendaftaranPasien = @idPendaftaranPasien And idJenisPerawatan = 1/*Ranap*/ And idJenisPendaftaran In(1,2))
											 Then 6/*Billing Tagihan Ranap*/
										When Exists(Select 1 From dbo.transaksiPendaftaranPasien 
													 Where idPendaftaranPasien = @idPendaftaranPasien And idJenisPerawatan = 2/*RaJal*/ And idJenisPendaftaran = 1/*Igd*/)
											 Then 5/*Billing Tagihan IGD*/
										Else 1/*Billing Tagihan RaJal*/
								  End

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @bhpItem TABLE(idObatDetail int NOT NULL, jumlah Decimal(18,2) NOT NULL);

	INSERT INTO @bhpItem
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

	If Exists(Select 1 From dbo.transaksiKonsul Where idTransaksiKonsul = @idTransaksiKonsul And idStatusKonsul = 3)
		Begin
			Select 'Tidak Dapat Diupdate, Konsul Sudah Selesai' as respon, 0 as responCode;
		End
	Else If Exists(Select 1 From transaksiTindakanPasien 
					Where idTransaksiKonsul = @idTransaksiKonsul)
		Begin
			Select 'Gagal, Tindakan Telah Dientry' as respon, 0 as responCode;
		End
	Else
		Begin Try
			Begin Tran;
			/*UPDATE Ubah Status Konsul Menjadi Selesai*/
			UPDATE [dbo].[transaksiKonsul]
			   SET jawaban = @jawaban
				  ,anjuran = @anjuran
				  ,idStatusKonsul = 3
			 WHERE idTransaksiKonsul = @idTransaksiKonsul;
			
			/*INSERT Entry Tindakan Pasien*/
			INSERT INTO [dbo].[transaksiTindakanPasien]
					   ([idPendaftaranPasien]
					   ,[idTransaksiKonsul]
					   ,[idMasterTarif]
					   ,[idJenisBilling]
					   ,[idRuangan]
					   ,[idUserEntry]
					   ,[TglEntry]
					   ,[tglTindakan])
			  	 VALUES (@idPendaftaranPasien
					   ,@idTransaksiKonsul
					   ,@idMasterTarif
					   ,@idJenisBilling
					   ,@idRuangan
					   ,@idUserEntry
					   ,GETDATE()
					   ,@TglTindakan);

			/*GET @idTindakanPasien*/
			SET @idTindakanPasien = SCOPE_IDENTITY();

			/*INSERT Entry Tindakan Pasien Detail*/
			INSERT INTO [dbo].[transaksiTindakanPasienDetail]
					   ([idTindakanPasien]
					   ,[idMasterKatagoriTarip]
					   ,[nilai])
				 SELECT @idTindakanPasien
					   ,idMasterKatagoriTarip
					   ,tarip
				  FROM dbo.masterTaripDetail
				 WHERE idMasterTarip = @idMasterTarif And status = 1;	

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

			/*INSERT Tindakan BHP*/
			If Exists(Select 1 From @bhpItem Where IsNull(jumlah, 0) >= 1)
				Begin

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
							   ,c.hargaJual
							   ,b.jumlah
							   ,0/*Tidak Ditagih*/
						   FROM dbo.farmasiMasterObatDetail a
								Inner Join @bhpItem b On a.idObatDetail = b.idObatDetail
								Inner Join dbo.farmasiMasterObatDosis c On a.idObatDosis = c.idObatDosis
						  WHERE b.jumlah >= 1;

					/*INSERT Entry Log Penjualan*/
					INSERT INTO [dbo].[farmasiJurnalStok]
							   ([idObatDetail]
							   ,[idPenjualanDetail]
							   ,[stokAwal]
							   ,[jumlahKeluar]
							   ,[stokAkhir]
							   ,[idUserEntry])
						 SELECT b.idObatDetail
							   ,a.idPenjualanDetail
							   ,b.stok
							   ,a.jumlah
							   ,b.stok - a.jumlah
							   ,@idUserEntry
						   FROM dbo.farmasiPenjualanDetail a
								INNER JOIN dbo.farmasiMasterObatDetail b ON a.idObatDetail = b.idObatDetail
								INNER JOIN @bhpItem c ON a.idObatDetail = c.idObatDetail
						  WHERE a.idTindakanPasien = @idTindakanPasien;
						   
					/*UPDATE Stok BHP Ruangan*/
					UPDATE a
					   SET a.stok -= IsNull(b.jumlah, 0)
					  FROM dbo.farmasiMasterObatDetail a
						   INNER JOIN dbo.farmasiPenjualanDetail b On a.idObatDetail = b.idObatDetail
						   INNER JOIN @bhpItem c ON a.idObatDetail = c.idObatDetail
					 WHERE b.idTindakanPasien = @idTindakanPasien;
				End

			/*Transaction Commit*/
			Commit Tran;
			Select 'Data Berhasil Diupdate' AS respon, 1 AS responCode;
		End Try
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		End Catch
END