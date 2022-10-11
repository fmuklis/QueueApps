-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterTaripSelectForOK]
	-- Add the parameters for the stored procedure here
	@idKelas int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Distinct a.idMasterTarif, c.namaTarifHeader, a.Keterangan, c.BHP
	  FROM dbo.masterTarip a
		   Inner Join dbo.masterRuanganPelayanan b On a.idMasterPelayanan = b.idMasterPelayanan
				Inner Join dbo.masterRuangan ba On b.idRuangan = ba.idRuangan
		   Inner Join dbo.masterTarifHeader c On a.idMasterTarifHeader = c.idMasterTarifHeader
		   Inner Join dbo.masterTaripDetail d On a.idMasterTarif = d.idMasterTarip
	 WHERE ba.idJenisRuangan = 5/*Instalasi Bedah Sentral*/ And a.idKelas = @idKelas 
  ORDER BY c.namaTarifHeader
END