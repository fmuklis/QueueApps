
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[getInfo_listBiayaKamarRawatInap]
(
	-- Add the parameters for the function here
	@idPendaftaranPasien bigint
)
RETURNS TABLE
AS
RETURN
(
	-- Add the SELECT statement with parameter references here
	SELECT ba.namaRuanganRawatInap +' / Bed : '+ CAST(b.noTempatTidur As varchar(10)) AS kamarInap, bb.namaRuangan AS ruanganInap
		  ,a.tanggalMasuk, a.tanggalKeluar, a.lamaInap, a.tarifKamar
		  ,CASE
				WHEN a.ditagih = 1
					 THEN a.tarifKamar * a.lamaInap
				ELSE 0
			END AS jmlBiayaInap
		  ,CASE
				WHEN a.ditagih = 1
					 THEN 'Ditagih'
				ELSE 'Tidak Ditagih / Paket'
			END AS keterangan
	  FROM dbo.transaksiPendaftaranPasienDetail a
		   LEFT JOIN dbo.masterRuanganTempatTidur b On a.idTempatTidur = b.idTempatTidur
				LEFT JOIN dbo.masterRuanganRawatInap ba On b.idRuanganRawatInap = ba.idRuanganRawatInap
				LEFT JOIN dbo.masterRuangan bb On ba.idRuangan = bb.idRuangan
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
)