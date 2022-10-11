-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laporanRL33sampai310]
	-- Add the parameters for the stored procedure here
	@periodeAwal date
	,@periodeAkhir date
	,@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ba.namaTarifHeader, Count(a.idTindakanPasien) As jumlah
	  FROM dbo.transaksiTindakanPasien a
		   Inner Join dbo.masterTarip b On a.idMasterTarif = b.idMasterTarif And b.idJenisTarif In(4,5,8)
				Inner Join dbo.masterTarifHeader ba On b.idMasterTarifHeader = ba.idMasterTarifHeader
	 WHERE Convert(date, a.tglTindakan) Between @periodeAwal And @periodeAkhir And a.idRuangan = @idRuangan
  GROUP BY ba.namaTarifHeader
END