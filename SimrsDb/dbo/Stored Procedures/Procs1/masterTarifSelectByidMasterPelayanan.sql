-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterTarifSelectByidMasterPelayanan]
	-- Add the parameters for the stored procedure here
	@idMasterPelayanan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idMasterTarif, f.namaTarifHeader +' ('+ c.namaKelas +')' As namaTarif, d.namaJenisTarif, e.namaSatuanTarif
		  ,(Select Sum(tarip) From dbo.masterTaripDetail xa 
			 Where a.idMasterTarif = xa.idMasterTarip And xa.status = 1) As tarif
	  FROM dbo.masterTarip a
		   Inner Join dbo.masterKelas c On a.idKelas = c.idKelas
		   Inner Join dbo.masterJenisTarif d On a.idJenisTarif = d.idJenisTarif
		   Inner Join dbo.masterSatuanTarif e On a.idSatuanTarif = e.idSatuanTarif
		   Inner Join dbo.masterTarifHeader f On a.idMasterTarifHeader = f.idMasterTarifHeader
	 WHERE a.idMasterPelayanan = @idMasterPelayanan
  ORDER BY a.idKelas, f.namaTarifHeader;
END