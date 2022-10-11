-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiTindakanLabInsert]
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
		   ,@idOrderDetail int
		   ,@pasienInap bit = Case
								   When Exists(Select 1 From dbo.transaksiOrder a
													  Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
												Where a.idOrder = @idOrder And b.idJenisPerawatan = 1/*Rawat Inap*/)
										Then 1
								   Else 0
							   End
	Declare @idJenisBilling Int = Case
									   When @pasienInap = 1
											Then 6/*Billing Tagihan Ranap*/
									   Else 2/*Billing Tagihan Lab*/
								   End
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Begin Try
		Begin Tran tranzTindakanLabInsert7565;
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
		Select @idOrderDetail = idOrderDetail From dbo.transaksiOrderDetail Where idOrder = @idOrder And idMasterTarif = @idMasterTarif;
		If Not Exists(Select 1 From dbo.transaksiTindakanPasien Where idOrderDetail = @idOrderDetail)
			Begin
				INSERT INTO [dbo].[transaksiTindakanPasien]
						   ([idPendaftaranPasien]
						   ,[idOrderDetail]
						   ,[idJenisBilling]
						   ,[idRuangan]
						   ,[idMasterTarif]
						   ,[tglTindakan]
						   ,[idUserEntry]
						   ,[TglEntry])
					 SELECT a.idPendaftaranPasien
						   ,b.idOrderDetail
						   ,@idJenisBilling
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
		Commit Tran tranzTindakanLabInsert7565;
		Select 'Data Berhasil Disimpan' As respon, 1 As responCode;
	End Try
	Begin Catch
		Rollback Tran tranzTindakanLabInsert7565;
		Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
	End Catch
END