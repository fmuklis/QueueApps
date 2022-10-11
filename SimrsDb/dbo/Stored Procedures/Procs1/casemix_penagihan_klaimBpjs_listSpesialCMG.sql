-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[casemix_penagihan_klaimBpjs_listSpesialCMG]
	-- Add the parameters for the stored procedure here
	@idBilling int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idTransaksiBillingCMG, a.idMasterCMGType, a.kodeCMG, a.[description], a.kode, a.tarif, a.jumlahTarif
	  FROM dbo.getinfo_listSpesialCMG(@idBilling) a
END