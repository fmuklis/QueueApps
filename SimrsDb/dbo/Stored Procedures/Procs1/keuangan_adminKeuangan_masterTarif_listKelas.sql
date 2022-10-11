-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[keuangan_adminKeuangan_masterTarif_listKelas]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Distinct a.idMasterPelayanan, b.idKelas, ba.namaKelas
	  FROM dbo.masterPelayanan a
		   Inner Join dbo.masterTarip b On a.idMasterPelayanan = b.idMasterPelayanan
				Inner Join dbo.masterKelas ba On b.idKelas = ba.idKelas
  ORDER BY a.idMasterPelayanan
END