-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[rajal_perawatPoli_pasienKonsul_listDaftarPasienKonsul]
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idTransaksiKonsul ,a.idStatusKonsul ,a.tglOrderKonsul
		   ,b.idPendaftaranPasien ,b.idStatusPendaftaran ,b.idRuangan ,ba.namaRuangan 
		   ,c.kodePasien ,c.noRM ,c.namaPasien ,c.tglLahirPasien ,c.umur ,c.namaJenisKelamin AS jenisKelamin 
		   ,Case
				 When Exists(Select 1 From dbo.transaksiTindakanPasien xa
							  Where xa.idPendaftaranPasien = a.idPendaftaranPasien And xa.idRuangan = a.idRuanganTujuan)
					  Then 1
				 Else 0
			End As flagTindakan
	  FROM dbo.transaksiKonsul a
		   Inner Join dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
		   		Inner Join dbo.masterRuangan ba On b.idRuangan = ba.idRuangan
		   OUTER APPLY dbo.getInfo_dataPasien(b.idPasien) c
		   Inner Join dbo.masterStatusKonsul d on a.idStatusKonsul = d.idStatusKonsul
	 WHERE a.idStatusKonsul = 2/*Order Konsul Diterima*/ And a.idRuanganTujuan = @idRuangan
  ORDER BY a.tglOrderKonsul;
END