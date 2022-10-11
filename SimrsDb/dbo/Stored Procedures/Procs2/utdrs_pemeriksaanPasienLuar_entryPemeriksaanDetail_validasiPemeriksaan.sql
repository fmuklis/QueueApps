-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[utdrs_pemeriksaanPasienLuar_entryPemeriksaanDetail_validasiPemeriksaan]
	-- Add the parameters for the stored procedure here
	@idOrder int,
	@listOperator nvarchar(250),
	@idUser int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idPasienLuar int = (Select idPasienLuar From dbo.transaksiOrder Where idOrder = @idOrder);

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

	If Not Exists(Select 1 From dbo.transaksiOrderDetail a
						 Inner Join dbo.transaksiTindakanPasien b On a.idOrderDetail = b.idOrderDetail
				   Where a.idOrder = @idOrder)
		Begin
			Select 'Tidak Dapat Divalidasi, Pemeriksaan UTDRS Belum Dientry' AS respon, 0 AS responCode; 
		End
	Else
		Begin Try
			/*Transaction Begin*/
			Begin Tran;

			/*UPDATE Status Order Labor*/
			UPDATE [dbo].[transaksiOrder]
			   SET [nomorUtdrs] = dbo.generate_nomorUtdrs(GETDATE())
				  ,[tanggalHasil] = GETDATE()
				  ,[idStatusOrder] = 3/*Selesai*/
			 WHERE idOrder = @idOrder;

			/*INSERT Operator Tindakan*/
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
								Inner Join dbo.transaksiTindakanPasien c On a.idTindakanPasien = c.idTindakanPasien
									Inner Join dbo.transaksiOrderDetail ca On c.idOrderDetail = ca.idOrderDetail
						  WHERE	ca.idOrder = @idOrder;
				End

			/*INSERT Create Billing UTDRS*/
			INSERT INTO [dbo].[transaksiBillingHeader]
					   ([kodeBayar]
					   ,[idPasienLuar]
					   ,[idOrder]
					   ,[idJenisBilling]
					   ,[idUserEntry])
				 VALUES
					   (dbo.noKwitansi()
					   ,@idPasienLuar
					   ,@idOrder
					   ,7/*Billing UTDRS*/
					   ,@idUser);

			/*Transaction Commit*/
			Commit Tran;

			/*Respon*/
			Select 'Pemeriksaan UTDRS Berhasil Divalidasi' AS respon, 1 AS responCode;
		End Try
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;

			/*Respon*/
			Select 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		End Catch
END