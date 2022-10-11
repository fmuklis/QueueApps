-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiTindakanPasienLab]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int
	,@idOrder int
	 AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT d.namaMasterPelayanan,b.namaTarif,a.tglTindakan,SUM(c.tarip) as Tarif
	FROM [dbo].[transaksiTindakanPasien] a
			Inner join [dbo].[masterTarip] b On a.idMasterTarif = b.idMasterTarif
			Inner Join dbo.masterTaripDetail c on a.idMasterTarif = c.idMasterTarip
			Inner Join dbo.masterPelayanan d On b.idMasterPelayanan = d.idMasterPelayanan
			inner join dbo.transaksiPendaftaranPasien e on a.idPendaftaranPasien = e.idPendaftaranPasien
			inner join dbo.transaksiOrder f on e.idPendaftaranPasien = f.idPendaftaranPasien
	WHERE a.idPendaftaranPasien = @idPendaftaranPasien And d.idMasterPelayanan = 18 and f.idOrder = @idOrder
	GROUP BY d.namaMasterPelayanan,b.namaTarif,a.tglTindakan
	ORDER BY d.namaMasterPelayanan,a.tglTindakan
  
END