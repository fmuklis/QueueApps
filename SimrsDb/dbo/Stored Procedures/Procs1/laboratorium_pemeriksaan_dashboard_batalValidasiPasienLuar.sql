-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[laboratorium_pemeriksaan_dashboard_batalValidasiPasienLuar]
	-- Add the parameters for the stored procedure here
	@idOrder int,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiBillingHeader a
			   WHERE a.idOrder = @idOrder AND a.idStatusBayar <> 1/*Menunggu Pembayaran*/)
		BEGIN
			SELECT 'Tidak Dapat Batal Validasi, Biaya Pemeriksaan Telah Dibayar' AS respon, 0 AS responCode;
		END		
	ELSE
		BEGIN
			/*Delete Billing*/
			DELETE dbo.transaksiBillingHeader
			 WHERE idOrder = @idOrder;

			/*UPDATE Data Order Laboratorium*/
			UPDATE [dbo].[transaksiOrder]
			   SET [idStatusOrder] = 2/*Order Diterima*/
			 WHERE idOrder = @idOrder;

			SELECT 'Validasi Pemeriksaan Laboratorium Dibatalkan' As respon, 1 As responCode;
		END
END