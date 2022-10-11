-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiOrderLabBatalPeriksa]
	-- Add the parameters for the stored procedure here
	@idOrder int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idPendaftaranPasien int 
		   ,@pasienUMUM bit 
		   
	 Select @idPendaftaranPasien = a.idPendaftaranPasien
		   ,@pasienUMUM = Case
							   When ba.idJenisPenjaminInduk = 1/*UMUM*/
									Then 1
							   Else 0
						 End
	 From dbo.transaksiOrder a
		  Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				Inner Join dbo.masterJenisPenjaminPembayaranPasien ba On b.idJenisPenjaminPembayaranPasien = ba.idJenisPenjaminPembayaranPasien
	Where a.idOrder = @idOrder

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If @pasienUMUM = 1 And Exists(Select 1 From dbo.transaksiBillingHeader a
								   Where a.idOrder = @idOrder And a.idJenisBayar Is Not Null)
		Begin
			Select 'Gagal!: Pasien Telah Membayar Biaya Pemeriksaan' As respon, 0 As responCode;
		End		
	Else	
		Begin Try
			Begin Tran tranzOrderLabBatalPeriksa76;
			--Update Status Order
			UPDATE [dbo].[transaksiOrder]
			   SET idStatusOrder = 1
			 WHERE idOrder = @idOrder;
			--Menghapus Billing Yang Terbuat
			DELETE a
			  FROM dbo.transaksiBillingHeader a
			  	   Inner Join dbo.transaksiOrderDetail b On a.idOrder = b.idOrder
				  WHERE b.idOrder = @idOrder;
			--Menghapus Daftar Tindakan
			DELETE a
			  FROM dbo.transaksiTindakanPasien a
				   Inner Join dbo.transaksiOrderDetail b On a.idOrderDetail = b.idOrderDetail 
				  WHERE b.idOrder = @idOrder;
			--Respon
			Commit Tran tranzOrderLabBatalPeriksa76;
			Select 'Pemeriksaan Laboratorium Dibatalkan' As respon, 1 As responCode;
		End Try
		Begin Catch
			Rollback Tran tranzOrderLabBatalPeriksa76;
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch
END