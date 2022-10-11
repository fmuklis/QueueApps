-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_laporan_rl314_listDataTahunan]
	-- Add the parameters for the stored procedure here
	@tahun int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT jenisSpesialisasi, Sum(jmlRujukPuskesmas) As jmlRujukPuskesmas, Sum(jmlRujuklain) As jmlRujuklain, Sum(jmlRujukRs) As jmlRujukRs
		  ,Sum(jmlDikembalikanPuskes) As jmlDikembalikanPuskes, Sum(jmlDikembalikanlain) As jmlDikembalikanlain, Sum(jmlDikembalikanRs) As jmlDikembalikanRs
		  ,Sum(jmlPxRujukan) jmlPxRujukan, Sum(jmlPxDatangSendiri) As jmlPxDatangSendiri, Sum(jmlDiterimaKembali) As jmlDiterimaKembali
	  FROM (Select Case
						When a.idJenisOperator In(1,5)
							 Then 'Spesialisasi Lain'
						Else Replace(a.namaJenisOperator, 'Dokter ', '')
					End As jenisSpesialisasi
				  ,b.jmlRujukPuskesmas, c.jmlRujuklain, d.jmlRujukRs, e.jmlDikembalikanPuskes, f.jmlDikembalikanlain, g.jmlDikembalikanRs
				  ,h.jmlPxRujukan, i.jmlPxDatangSendiri, 0 As jmlDiterimaKembali
			  From dbo.masterOperatorJenis a
				   Cross Apply (Select Count(xb.idPendaftaranPasien) As jmlRujukPuskesmas
								  From dbo.masterOperator xa
									   Inner Join dbo.transaksiPendaftaranPasien xb On xa.idOperator = xb.idDokter
									   Inner Join dbo.masterAsalPasien xc On xb.idAsalPasien = xc.idAsalPasien
								 Where xa.idJenisOperator = a.idJenisOperator And Year(tglDaftarPasien) = @tahun
									   And xb.idAsalPasien = 1 And xc.idJenisFaskes = 2) b
				   Cross Apply (Select Count(xb.idPendaftaranPasien) As jmlRujuklain
								  From dbo.masterOperator xa
									   Inner Join dbo.transaksiPendaftaranPasien xb On xa.idOperator = xb.idDokter
									   Inner Join dbo.masterAsalPasien xc On xb.idAsalPasien = xc.idAsalPasien
								 Where xa.idJenisOperator = a.idJenisOperator And Year(tglDaftarPasien) = @tahun
									   And xb.idAsalPasien = 1 And xc.idJenisFaskes = 3) c
				   Cross Apply (Select Count(xb.idPendaftaranPasien) As jmlRujukRs
								  From dbo.masterOperator xa
									   Inner Join dbo.transaksiPendaftaranPasien xb On xa.idOperator = xb.idDokter
									   Inner Join dbo.masterAsalPasien xc On xb.idAsalPasien = xc.idAsalPasien
								 Where xa.idJenisOperator = a.idJenisOperator And Year(tglDaftarPasien) = @tahun
									   And xb.idAsalPasien = 1 And xc.idJenisFaskes = 1) d
				   Cross Apply (Select Count(xb.idPendaftaranPasien) As jmlDikembalikanPuskes
								  From dbo.masterOperator xa
									   Inner Join dbo.transaksiPendaftaranPasien xb On xa.idOperator = xb.idDokter
									   Inner Join dbo.masterAsalPasien xc On xb.idAsalPasien = xc.idAsalPasien
								 Where xa.idJenisOperator = a.idJenisOperator And Year(tglDaftarPasien) = @tahun
									   And xb.idAsalPasien = 1/*Rujukan*/ And xc.idJenisFaskes = 2/*Puskes*/ And xb.idStatusPasien = 9/*Rujuk Balik*/) e
				   Cross Apply (Select Count(xb.idPendaftaranPasien) As jmlDikembalikanlain
								  From dbo.masterOperator xa
									   Inner Join dbo.transaksiPendaftaranPasien xb On xa.idOperator = xb.idDokter
									   Inner Join dbo.masterAsalPasien xc On xb.idAsalPasien = xc.idAsalPasien
								 Where xa.idJenisOperator = a.idJenisOperator And Year(tglDaftarPasien) = @tahun
									   And xb.idAsalPasien = 1/*Rujukan*/ And xc.idJenisFaskes = 3/*Lain*/ And xb.idStatusPasien = 9/*Rujuk Balik*/) f
				   Cross Apply (Select Count(xb.idPendaftaranPasien) As jmlDikembalikanRs
								  From dbo.masterOperator xa
									   Inner Join dbo.transaksiPendaftaranPasien xb On xa.idOperator = xb.idDokter
									   Inner Join dbo.masterAsalPasien xc On xb.idAsalPasien = xc.idAsalPasien
								 Where xa.idJenisOperator = a.idJenisOperator And Year(tglDaftarPasien) = @tahun
									   And xb.idAsalPasien = 1/*Rujukan*/ And xc.idJenisFaskes = 1/*Puskes*/ And xb.idStatusPasien = 9/*Rujuk Balik*/) g
				   Cross Apply (Select Count(xb.idPendaftaranPasien) As jmlPxRujukan
								  From dbo.masterOperator xa
									   Inner Join dbo.transaksiPendaftaranPasien xb On xa.idOperator = xb.idDokter
								 Where xa.idJenisOperator = a.idJenisOperator And Year(tglDaftarPasien) = @tahun
									   And xb.rujukan = 1) h
				   Cross Apply (Select Count(xb.idPendaftaranPasien) As jmlPxDatangSendiri
								  From dbo.masterOperator xa
									   Inner Join dbo.transaksiPendaftaranPasien xb On xa.idOperator = xb.idDokter
								 Where xa.idJenisOperator = a.idJenisOperator And Year(tglDaftarPasien) = @tahun
									   And IsNull(xb.rujukan, 0) <> 1) i
			 Where a.idMasterKatagoriTarip = 1) As dataSet
	GROUP BY jenisSpesialisasi
	ORDER BY jenisSpesialisasi
END