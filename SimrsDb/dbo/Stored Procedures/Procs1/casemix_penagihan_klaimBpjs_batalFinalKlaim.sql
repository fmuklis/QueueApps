-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[casemix_penagihan_klaimBpjs_batalFinalKlaim]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[transaksiBillingHeader]
		SET [idStatusKlaim] = 5
	WHERE idBilling = @idBilling

	SELECT 'Klaim Berhasil Dibatalkan' AS respon, 1 AS responCode;
END