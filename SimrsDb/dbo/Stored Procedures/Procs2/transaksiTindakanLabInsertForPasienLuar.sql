-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiTindakanLabInsertForPasienLuar]
	-- Add the parameters for the stored procedure here
	@idOrder int
	,@idMasterTarif int
	,@idUserEntry int
	,@tglTindakan date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idTindakanPasien int
		   ,@idOrderDetail int;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiOrder Where idOrder = @idOrder And idStatusOrder = 3/*Selesai Pemeriksaan*/)
		Begin
			Select 'Tidak Dapat Disimpan, Pemeriksaan Telah Selesai' As respon, 0 As responCode;
		End
	Else
		Begin Try
			/*Transaction Begin*/
			Begin Tran;

			/*INSERT Order Detail*/
			If Not Exists(Select 1 From dbo.transaksiOrderDetail
						   Where idOrder = @idOrder And idMasterTarif = @idMasterTarif)
				Begin
					INSERT INTO [dbo].[transaksiOrderDetail]
							   ([idOrder]
							   ,[idMasterTarif])
						 VALUES
							   (@idOrder
							   ,@idMasterTarif);
				End
			
			/*GET idOrderDetail*/
			Select @idOrderDetail = idOrderDetail From dbo.transaksiOrderDetail Where idOrder = @idOrder And idMasterTarif = @idMasterTarif;

			/*INSERT Entry Tindakan Pasien*/
			If Not Exists(Select 1 From dbo.transaksiTindakanPasien Where idOrderDetail = @idOrderDetail)
				Begin
					INSERT INTO [dbo].[transaksiTindakanPasien]
							   ([idOrderDetail]
							   ,[idJenisBilling]
							   ,[idRuangan]
							   ,[idMasterTarif]
							   ,[tglTindakan]
							   ,[idUserEntry]
							   ,[TglEntry])
						 SELECT b.idOrderDetail
							   ,2/*Billing Tagihan Lab*/
							   ,a.idRuanganTujuan
							   ,b.idMasterTarif
							   ,@tglTindakan
							   ,@idUserEntry
							   ,GetDate()
						   FROM dbo.transaksiOrder a
								Inner Join dbo.transaksiOrderDetail b On a.idOrder = b.idOrder
						  WHERE b.idOrderDetail = @idOrderDetail;

					INSERT INTO [dbo].[transaksiTindakanPasienDetail]
							   ([idTindakanPasien]
							   ,[idMasterKatagoriTarip]
							   ,[nilai])
						 SELECT a.idTindakanPasien
							   ,b.idMasterKatagoriTarip
							   ,b.tarip
						   FROM dbo.transaksiTindakanPasien a
								Inner Join dbo.masterTaripDetail b On a.idMasterTarif = b.idMasterTarip
						  WHERE a.idOrderDetail = @idOrderDetail And b.status = 1;
				End

			/*Transaction Commit*/
			Commit Tran;

			/*REspon*/
			Select 'Data Berhasil Disimpan' As respon, 1 As responCode;
		End Try
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;

			/*Respon*/
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch
END