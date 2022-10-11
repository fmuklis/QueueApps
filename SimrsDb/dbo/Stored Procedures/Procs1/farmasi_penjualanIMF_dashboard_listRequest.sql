-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE farmasi_penjualanIMF_dashboard_listRequest
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
    @idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStok int = (Select idJenisStok From dbo.masterRuangan Where idRuangan = @idRuangan)

	SET NOCOUNT ON;

    -- Insert statements for procedure here

	SELECT a.idIMF, a.idPendaftaranPasien, a.tglIMF, a.noIMF, da.noRM, da.namaPasien, da.namaJenisKelamin AS jenisKelamin
		  ,da.tglLahirPasien, da.umur, c.NamaOperator, b.namaRuangan
	  FROM dbo.farmasiIMF a
	       INNER JOIN dbo.masterRuangan b ON a.idRuangan = b.idRuangan AND b.idJenisStok = @idJenisStok
		   LEFT JOIN dbo.masterOperator c ON a.idDokter = c.idOperator
		   INNER JOIN dbo.transaksiPendaftaranPasien d ON a.idPendaftaranPasien = d.idPendaftaranPasien
				OUTER APPLY dbo.getInfo_dataPasien(d.idPasien) da
	 WHERE d.idStatusPendaftaran < 98 /*And a.tglIMF Between @periodeAwal And @periodeAkhir*/
END