-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[keuangan_adminKeuangan_masterTarif_dataTarif]
	-- Add the parameters for the stored procedure here
	@idMasterTarif int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idMasterTarif, d.idJenisTarif, d.namaJenisTarif, b.idMasterTarifHeader, b.namaTarifHeader, b.BHP
		  ,f.idKelas, f.namaKelas, e.idSatuanTarif, e.namaSatuanTarif, ca.idMasterKatagoriTarip, c.tarip
	  FROM dbo.masterTarip a
		   Inner Join dbo.masterTarifHeader b On a.idMasterTarifHeader = b.idMasterTarifHeader
		   Left Join dbo.masterTaripDetail c On a.idMasterTarif = c.idMasterTarip And c.status = 1
				Left Join dbo.masterTarifKatagori ca On c.idMasterKatagoriTarip = ca.idMasterKatagoriTarip
		   Inner Join [dbo].[masterJenisTarif] d On a.idJenisTarif = d.idJenisTarif
		   Inner Join dbo.masterSatuanTarif e On a.idSatuanTarif = e.idSatuanTarif
		   Inner Join dbo.masterKelas f On a.idKelas = f.idKelas
	 WHERE a.idMasterTarif = @idMasterTarif
  ORDER BY ca.namaMasterKatagoriInProgram
END