-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_laporan_rekapPenjualan_listUnitPenjualan]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT CASE
				WHEN a.idJenisStok = 6/*BHP Ruangan*/
					 THEN 0
				ELSE a.idJenisStok
			END AS idUnitPenjualan
		  ,CASE
				WHEN a.idJenisStok = 6/*BHP Ruangan*/
					 THEN 'BHP Ruangan'
				ELSE a.namaJenisStok
			END AS unitPenjualan
	  FROM dbo.farmasiMasterObatJenisStok a
  ORDER BY a.idJenisStok
END