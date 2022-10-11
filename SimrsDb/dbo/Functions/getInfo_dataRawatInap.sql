-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[getInfo_dataRawatInap]
(	
	-- Add the parameters for the function here
	@idPendaftaranPasien bigint
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	WITH dataPendaftaran AS (
		 SELECT MIN(a.tanggalMasuk) AS tanggalMasukRawatInap, MAX(a.tanggalKeluar) AS tanggalKeluarRawatInap
		   FROM dbo.transaksiPendaftaranPasienDetail a
		  WHERE a.idPendaftaranPasien = @idPendaftaranPasien)

	SELECT a.idTempatTidur, a.idJenisPelayananRawatInap, b.idRuanganRawatInap, ba.idRuangan
		  ,a.idPendaftaranPasienDetail, a.idStatusPendaftaranRawatInap
		  ,a.tanggalMasuk, d.tanggalMasukRawatInap, d.tanggalKeluarRawatInap
		  ,CONCAT(ba.namaRuanganRawatInap, ' / Bed : ', b.noTempatTidur) AS kamarInap
		  ,bb.namaRuangan AS ruanganInap, c.jenisPelayananRawatInap
	  FROM dbo.transaksiPendaftaranPasienDetail a
		   LEFT JOIN dbo.masterRuanganTempatTidur b ON a.idTempatTidur = b.idTempatTidur
				LEFT JOIN dbo.masterRuanganRawatInap ba ON b.idRuanganRawatInap = ba.idRuanganRawatInap
				LEFT JOIN dbo.masterRuangan bb ON ba.idRuangan = bb.idRuangan
		   LEFT JOIN dbo.consJenisPelayananRawatInap c ON a.idJenisPelayananRawatInap = c.idJenisPelayananRawatInap
		   OUTER APPLY dataPendaftaran d
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND a.aktif = 1/*true*/
)