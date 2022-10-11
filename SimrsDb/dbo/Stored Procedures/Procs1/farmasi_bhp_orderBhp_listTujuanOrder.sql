-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		Start-X
-- Create date: <Create Date,,>
-- Description:	Menampilkan Tujuan Permintaan Item Farmasi
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_bhp_orderBhp_listTujuanOrder]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT idJenisStok, namaJenisStok
	  FROM dbo.farmasiMasterObatJenisStok
	 WHERE idJenisStok BETWEEN 1 AND 5
  ORDER BY namaJenisStok
END