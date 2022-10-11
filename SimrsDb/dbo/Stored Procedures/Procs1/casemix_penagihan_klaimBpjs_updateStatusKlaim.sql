-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[casemix_penagihan_klaimBpjs_updateStatusKlaim]
	-- Add the parameters for the stored procedure here
	@idBilling bigint,
	@idStatusKlaim tinyint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

	IF @idStatusKlaim = 6
		BEGIN
			SET @idStatusKlaim = 4/*Grouping Stage 1*/
		END

	UPDATE dbo.transaksiBillingHeader
	   SET idStatusKlaim = @idStatusKlaim
	 WHERE idBilling = @idBilling;

	Select 'Status Billing Berhasil Diupdate, '+ b.caption As respon, 1 As responCode
	  From dbo.transaksiBillingHeader a
			INNER JOIN dbo.masterStatusKlaim b ON a.idStatusKlaim = b.idStatusKlaim
	 Where a.idBilling = @idBilling;
END