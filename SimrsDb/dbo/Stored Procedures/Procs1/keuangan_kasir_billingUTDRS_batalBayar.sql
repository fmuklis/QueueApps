-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingUTDRS_batalBayar]
	-- Add the parameters for the stored procedure here
	@idBilling int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here

	IF EXISTS(SELECT 1 FROM dbo.transaksiOrder a INNER JOIN dbo.transaksiBillingHeader b ON a.idOrder = b.idOrder
			   WHERE b.idBilling = @idBilling AND a.idStatusOrder <> 3/*Selesai Entry Pemeriksaan*/)
		BEGIN
			SELECT 'Tidak Dapat Dibatalkan, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.transaksiOrder a
				   LEFT JOIN dbo.masterStatusOrder b ON a.idStatusOrder = b.idStatusOrder
				   INNER JOIN dbo.transaksiBillingHeader c ON a.idOrder = c.idOrder
			 WHERE c.idBilling = @idBilling;
		END
	ELSE
		BEGIN
			/*UPDATE Status Billing*/
			UPDATE [dbo].[transaksiBillingHeader]
			   SET [tglBayar] = NULL
				  ,[idUserBayar] = NULL
				  ,[idJenisBayar] = NULL
				  ,[idStatusBayar] = 1/*Menunggu Pembayaran*/
				  ,[keterangan] = NULL
			 WHERE [idBilling] = @idBilling;

			Select 'Tagihan Billing UTDRS Batal Dibayar' AS respon, 1 AS responCode;
		END
END