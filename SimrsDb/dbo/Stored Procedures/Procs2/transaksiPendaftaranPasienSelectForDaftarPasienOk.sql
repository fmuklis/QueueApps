-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Daftar Pasien Permintaan Perawatan
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienSelectForDaftarPasienOk]	
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here0
    SELECT d.idTransaksiOrderOK, a.idPendaftaranPasien, b.noRM, b.namaPasien, b.namaJenisKelamin AS jenisKelamin
		  ,b.tglLahirPasien, b.umur, d.tglOrder, e.penjamin AS namaJenisPenjaminInduk, f.namaRuangan, d.idStatusOrderOK
		  ,CASE a.idJenisPerawatan
				WHEN 2
					 THEN 1
				ELSE 0
			END AS dashbordRajal
	 FROM dbo.transaksiPendaftaranPasien a
		  OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
		  Inner Join dbo.transaksiOrderOK d On a.idPendaftaranPasien = d.idPendaftaranPasien
		  OUTER APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) e
		  Inner Join dbo.masterRuangan f On a.idRuangan = f.idRuangan
    WHERE a.idStatusPendaftaran < 98 And d.idStatusOrderOK > = 2
 ORDER BY d.tglOrder;
END