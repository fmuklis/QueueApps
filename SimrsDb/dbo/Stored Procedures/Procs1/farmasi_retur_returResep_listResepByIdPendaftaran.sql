-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_returResep_listResepByIdPendaftaran] 
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.idResep, c.namaRuangan, a.noResep, a.tglResep, 'Resep '+ ca.namaJenisRuangan AS namaResep, d.NamaOperator AS DPJP
		  ,CASE
				WHEN b.idBilling IS NOT NULL
					 THEN 0
				ELSE 1
			END AS flagRetur
	  FROM dbo.farmasiResep a
		   INNER JOIN dbo.farmasiPenjualanHeader b On a.idResep = b.idResep
		   LEFT JOIN dbo.masterRuangan c On a.idRuangan = c.idRuangan
			   LEFT JOIN dbo.masterRuanganJenis ca On c.idJenisRuangan = ca.idJenisRuangan
		   LEFT JOIN dbo.masterOperator d ON a.idDokter = d.idOperator
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
  ORDER BY a.idResep
END