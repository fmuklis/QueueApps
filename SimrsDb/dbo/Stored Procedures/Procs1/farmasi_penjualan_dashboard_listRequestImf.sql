-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_penjualan_dashboard_listRequestImf] 
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStok int = (SELECT idJenisStok FROM dbo.masterRuangan WHERE idRuangan = @idRuangan)

	SET NOCOUNT ON;

    -- Insert statements for procedure here

	SELECT a.idIMF, a.idPendaftaranPasien, a.tglIMF, a.noIMF, da.noRM, da.namaPasien, da.namaJenisKelamin
		  ,da.tglLahirPasien, da.umur, c.namaOperator, b.Alias
	  FROM dbo.farmasiIMF a
	       INNER JOIN dbo.masterRuangan b ON a.idRuangan = b.idRuangan
		   INNER JOIN dbo.masterOperator c ON a.idDokter = c.idOperator
		   INNER JOIN dbo.transaksiPendaftaranPasien d ON a.idPendaftaranPasien = d.idPendaftaranPasien
				OUTER APPLY dbo.getInfo_dataPasien(d.idPasien) da
	 WHERE b.idJenisStok = @idJenisStok AND d.idStatusPendaftaran <= 98;
END