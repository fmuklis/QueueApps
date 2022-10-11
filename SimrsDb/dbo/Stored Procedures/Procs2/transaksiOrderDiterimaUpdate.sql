-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiOrderDiterimaUpdate]
	-- Add the parameters for the stored procedure here
	@idOrder int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idPendaftaranPasien int 
		Select Distinct @idPendaftaranPasien = idPendaftaranPasien From transaksiOrder Where idOrder = @idOrder;
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists (Select Top 1 1 from transaksiOrder Where idOrder = @idOrder)
		Begin
			/*If Exists (Select Top 1 1 From transaksiBillingHeader Where idPendaftaranPasien = @idPendaftaranPasien And idJenisBilling = 2)
				Begin */
					UPDATE [dbo].[transaksiOrder]
					   SET [idStatusOrder] = 2
					 WHERE idOrder = @idOrder;
					Select 'Order Diterima' as respon, 1 as responCode; 
				/*End
			Else
				Begin
					Select 'Pasien Belum Membayar, Silahkan Bayar Dikasir Terlebih Dahulu' as respon, 0 as responCode;
				End*/
		End
	Else
		Begin
			Select 'Data Tidak Ditemukan' as respon, 0 as responCode;
		End
END