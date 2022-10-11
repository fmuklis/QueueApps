-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[radiologi_pemeriksaan_dashboard_batalValidasi]
	-- Add the parameters for the stored procedure here
	@idOrder int,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idPendaftaranPasien bigint 
		   ,@pasienUMUM bit;
		   
	 Select @idPendaftaranPasien = a.idPendaftaranPasien
		   ,@pasienUMUM = Case
							   When ba.idJenisPenjaminInduk = 1/*UMUM*/
									Then 1
							   Else 0
						 End
	 From dbo.transaksiOrder a
		  Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				Inner Join dbo.masterJenisPenjaminPembayaranPasien ba On b.idJenisPenjaminPembayaranPasien = ba.idJenisPenjaminPembayaranPasien
	Where a.idOrder = @idOrder;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If @pasienUMUM = 1 AND EXISTS(SELECT 1 FROM dbo.transaksiBillingHeader a
								   WHERE a.idOrder = @idOrder AND a.idStatusBayar <> 1/*Menunggu Pembayaran*/)
		BEGIN
			SELECT 'Tidak Dapat Batal Validasi, Biaya Pemeriksaan Telah Dibayar' AS respon, 0 AS responCode;
		END		
	ELSE
		BEGIN
			/*Delete Billing*/
			DELETE dbo.transaksiBillingHeader
			 WHERE idOrder = @idOrder;

			/*UPDATE Data Order Radiologi*/
			UPDATE [dbo].[transaksiOrder]
			   SET [idStatusOrder] = 2/*Order Diterima*/
			 WHERE idOrder = @idOrder;

			SELECT 'Validasi Pemeriksaan Radiologi Dibatalkan' As respon, 1 As responCode;
		END
END