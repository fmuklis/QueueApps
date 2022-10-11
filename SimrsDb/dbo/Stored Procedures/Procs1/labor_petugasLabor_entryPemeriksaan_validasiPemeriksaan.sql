-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_petugasLabor_entryPemeriksaan_validasiPemeriksaan]
	-- Add the parameters for the stored procedure here
	@idOrder bigint,
	@tanggalSampel datetime,
	@listOperator varchar(250),
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idPendaftaranPasien bigint = (SELECT idPendaftaranPasien FROM dbo.transaksiOrder WHERE idOrder = @idOrder);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @operator TABLE(idMasterKatagoriTarip int NOT NULL, idOperator int NOT NULL);

	INSERT INTO @operator
			   (idMasterKatagoriTarip
			   ,idOperator)
		 SELECT Convert(int, Left(value, CharIndex('|', value)-1)) As idMasterKatagoriTarip
			   ,Convert(int, Right(value, CharIndex('|', Reverse(value))-1)) As idOperator
		   FROM STRING_SPLIT(@listOperator, ',') a
		  WHERE value <> '';

	IF Not Exists(Select Top 1 1 From dbo.transaksiOrderDetail a
						 Inner Join dbo.transaksiTindakanPasien b On a.idOrderDetail = b.idOrderDetail
				   Where a.idOrder = @idOrder)
		Begin
			Select 'Tidak Dapat Divalidasi, Pemeriksaan Laboratorium Belum Dientry' As respon, 0 As responCode; 
		End
	ELSE IF EXISTS(SELECT 1 FROM dbo.transaksiOrder WHERE idOrder = @idOrder AND idStatusOrder <> 2/*Order Diterima*/)
		BEGIN
			SELECT 'Tidak Dapat Divalidasi, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.transaksiOrder a
				   INNER JOIN dbo.masterStatusOrder b ON a.idStatusOrder = b.idStatusOrder
			 WHERE a.idOrder = @idOrder;
		END
	ELSE
		Begin Try
			/*Transaction Begin*/
			Begin Tran;

			/*UPDATE Status Order Labor*/
			UPDATE [dbo].[transaksiOrder]
			   SET [nomorLabor] = dbo.generate_nomorLab(@tanggalSampel)
				  ,[idStatusOrder] = 3/*Selesai*/
				  ,[tanggalSampel] = @tanggalSampel
				  ,[tanggalModifikasi] = GETDATE()
			 WHERE idOrder = @idOrder;

			/*UPDATE Jenis Billing*/
			UPDATE a
			   SET a.idJenisBilling = dbo.labor_generateIdJenisBilling(@idOrder)
			  FROM dbo.transaksiTindakanPasien a
				   INNER JOIN dbo.transaksiOrderDetail b ON a.idOrderDetail = b.idOrderDetail
			 WHERE b.idOrder = @idOrder;

			/*INSERT Operator Tindakan*/
			If Exists(Select 1 From @operator Where idMasterKatagoriTarip Is Not Null And idOperator Is Not Null)
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
								Inner Join dbo.transaksiTindakanPasien c On a.idTindakanPasien = c.idTindakanPasien
									Inner Join dbo.transaksiOrderDetail ca On c.idOrderDetail = ca.idOrderDetail
						  WHERE	ca.idOrder = @idOrder;
				End

			/*Verifikasi Generate Billing*/
			IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasien a
							 CROSS APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) b
							 LEFT JOIN dbo.transaksiBillingHeader c ON a.idPendaftaranPasien = c.idPendaftaranPasien AND c.idOrder = @idOrder
					   WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND a.idJenisPerawatan = 2/*Rawat Jalan*/
							 AND b.idJenisPenjaminInduk = 1/*UMUM*/ AND c.idBilling IS NULL)
				BEGIN
					INSERT INTO [dbo].[transaksiBillingHeader]
							   ([kodeBayar]
							   ,[idPendaftaranPasien]
							   ,[idDokter]
							   ,[idRuangan]
							   ,[idOrder]
							   ,[idJenisBilling]
							   ,[idUserEntry])
						 SELECT dbo.noKwitansi()
							   ,a.idPendaftaranPasien
							   ,a.idDokter
							   ,a.idRuanganAsal
							   ,a.idOrder
							   ,2/*Bill Tagihan Labor*/
							   ,@idUserEntry
						   FROM dbo.transaksiOrder a
						  WHERE a.idOrder = @idOrder;
				END
			
			/*Transaction Commit*/
			Commit Tran;
			Select 'Pemeriksaan Laboratorium Berhasil Divalidasi' As respon, 1 As responCode;
		End Try
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() As respon, NULL As responCode;
		End Catch
END