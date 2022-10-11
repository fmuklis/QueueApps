-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingRadiologi_listPembayaran]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPembayaran, b.namaMetodeBayar, a.jumlahBayar
	  FROM dbo.transaksiBillingPembayaran a
		   LEFT JOIN dbo.masterMetodeBayar b ON a.idMetodeBayar = b.idMetodeBayar
	 WHERE a.idBilling = @idBilling;
END