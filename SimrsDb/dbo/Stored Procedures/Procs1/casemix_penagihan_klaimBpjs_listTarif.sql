-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[casemix_penagihan_klaimBpjs_listTarif]
	-- Add the parameters for the stored procedure here
	@idBilling bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT d.idMasterTarifHeader, c.namaTindakan ,c.namaTarifGroup
		FROM dbo.transaksiBillingHeader a
			LEFT JOIN dbo.transaksiTindakanPasien b on a.idPendaftaranPasien = b.idPendaftaranPasien
			OUTER APPLY dbo.getInfo_biayaTindakan(b.idTindakanPasien) c
			LEFT JOIN dbo.masterTarip d on b.idMasterTarif = d.idMasterTarif
	where a.idBilling = @idBilling AND c.namaTarifGroup IS NULL
END