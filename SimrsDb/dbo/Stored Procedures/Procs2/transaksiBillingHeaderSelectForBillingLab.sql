-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiBillingHeaderSelectForBillingLab]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT bc.idRuangan, bc.namaRuangan
		  ,ca.idMasterPelayanan, ca.namaMasterPelayanan
	  FROM [dbo].[transaksiBillingHeader] a 
		   Inner Join dbo.transaksiBillingDetail b On a.idBilling = b.idBilling
				Inner Join dbo.transaksiOrderDetail ba On b.idMasterTarif = ba.idMasterTarif
				Inner Join dbo.transaksiOrder bb On ba.idOrder = bb.idOrder
				Inner Join dbo.masterRuangan bc On bb.idRuanganTujuan = bc.idRuangan
		   Inner Join masterTarip c On b.idMasterTarif = c.idMasterTarif
				Inner Join masterPelayanan ca On c.idMasterPelayanan = ca.idMasterPelayanan
	WHERE a.idPendaftaranPasien = @idPendaftaranPasien
 GROUP BY bc.idRuangan, bc.namaRuangan
		  ,ca.idMasterPelayanan, ca.namaMasterPelayanan
 ORDER BY bc.namaRuangan;
	END