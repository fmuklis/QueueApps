-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[laboratorium_pemeriksaan_entryTindakan_validasiPemeriksaanPasienLuar]
	-- Add the parameters for the stored procedure here
	@idOrder bigint,
	@tglSampel date,
	@listOperator varchar(250),
	@idUserEntry int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @operator TABLE(idMasterKatagoriTarip int NOT NULL, idOperator int NOT NULL);

	INSERT INTO @operator
			   (idMasterKatagoriTarip
			   ,idOperator)
		 SELECT Convert(int, Left(value, CharIndex('|', value)-1)) As idMasterKatagoriTarip
			   ,Convert(int, Right(value, CharIndex('|', Reverse(value))-1)) As idOperator
		   FROM STRING_SPLIT(@listOperator, ',') a
		  WHERE Trim(value) <> '';

	IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.transaksiOrderDetail a
						 INNER JOIN dbo.transaksiTindakanPasien b ON a.idOrderDetail = b.idOrderDetail
				   WHERE a.idOrder = @idOrder)
		BEGIN
			SELECT 'Tidak Dapat Divalidasi, Pemeriksaan Laboratorium Belum Dientry' AS respon, 0 AS responCode; 
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.transaksiOrder WHERE idOrder = @idOrder AND idStatusOrder <> 2/*Order Diterima*/)
		BEGIN
			SELECT 'Tidak Dapat Divalidasi, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.transaksiOrder a
				   INNER JOIN dbo.masterStatusOrder b ON a.idStatusOrder = b.idStatusOrder
			 WHERE a.idOrder = @idOrder;
		END
	Else
		Begin Try
			/*Transaction Begin*/
			Begin Tran;

			/*UPDATE Status Order Radiologi*/
			UPDATE [dbo].[transaksiOrder]
			   SET [nomorLabor] = dbo.generate_nomorLab(@tglSampel)
				  ,[tanggalSampel] = @tglSampel
				  ,[tanggalModifikasi] = GETDATE()
				  ,[idStatusOrder] = 3/*Selesai Pemeriksaan*/
			 WHERE idOrder = @idOrder;

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

			/*Generate Billing*/
			INSERT INTO [dbo].[transaksiBillingHeader]
					   ([kodeBayar]
					   ,[idPasienLuar]
					   ,[idDokter]
					   ,[idRuangan]
					   ,[idOrder]
					   ,[idJenisBilling]
					   ,[idUserEntry])
				 SELECT dbo.noKwitansi()
					   ,a.idPasienLuar
					   ,a.idDokter
					   ,a.idRuanganAsal
					   ,a.idOrder
					   ,2/*Billing Laboratorium*/
					   ,@idUserEntry
				   FROM dbo.transaksiOrder a
				  WHERE a.idOrder = @idOrder;
			
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