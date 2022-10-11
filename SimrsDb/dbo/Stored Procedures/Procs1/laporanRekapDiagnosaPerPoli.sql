-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laporanRekapDiagnosaPerPoli]
	-- Add the parameters for the stored procedure here
	@periodeAwal date
	,@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.namaPenyakit
	  FROM dbo.masterPenyakit a
		   Left Join (Select xd.idPenyakit, Count(xa.idPendaftaranPasien) As l1
						From dbo.transaksiPendaftaranPasien xa
							 Inner Join dbo.masterPasien xb On xa.idPasien = xb.idPasien
							 Inner Join dbo.transaksiDiagnosaPasien xc On xa.idPendaftaranPasien = xc.idPendaftaranPasien
							 Inner Join dbo.transaksiDiagnosaPasienDetail xd On xc.idDiagNosa = xd.idDiagnosa
					   Where Convert(date, xa.tglDaftarPasien) Between @periodeAwal And @periodeAkhir And xb.idJenisKelaminPasien = 1/*Laki-Laki*/
							 And DateDiff(year, xb.tglLahirPasien, xa.tglDaftarPasien) < 1
					Group By xd.idPenyakit) b On a.idPenyakit = b.idPenyakit
		   Left Join (Select xd.idPenyakit, Count(xa.idPendaftaranPasien) As P1
						From dbo.transaksiPendaftaranPasien xa
							 Inner Join dbo.masterPasien xb On xa.idPasien = xb.idPasien
							 Inner Join dbo.transaksiDiagnosaPasien xc On xa.idPendaftaranPasien = xc.idPendaftaranPasien
							 Inner Join dbo.transaksiDiagnosaPasienDetail xd On xc.idDiagNosa = xd.idDiagnosa
					   Where Convert(date, xa.tglDaftarPasien) Between @periodeAwal And @periodeAkhir And xb.idJenisKelaminPasien = 2/*Perempuan*/
							 And DateDiff(year, xb.tglLahirPasien, xa.tglDaftarPasien) Between 1 And 4
					Group By xd.idPenyakit) c On a.idPenyakit = c.idPenyakit
		   Left Join (Select xd.idPenyakit, Count(xa.idPendaftaranPasien) As l2
						From dbo.transaksiPendaftaranPasien xa
							 Inner Join dbo.masterPasien xb On xa.idPasien = xb.idPasien
							 Inner Join dbo.transaksiDiagnosaPasien xc On xa.idPendaftaranPasien = xc.idPendaftaranPasien
							 Inner Join dbo.transaksiDiagnosaPasienDetail xd On xc.idDiagNosa = xd.idDiagnosa
					   Where Convert(date, xa.tglDaftarPasien) Between @periodeAwal And @periodeAkhir And xb.idJenisKelaminPasien = 1/*Laki-Laki*/
							 And DateDiff(year, xb.tglLahirPasien, xa.tglDaftarPasien) Between 1 And 4
					Group By xd.idPenyakit) d On a.idPenyakit = d.idPenyakit
		   Left Join (Select xd.idPenyakit, Count(xa.idPendaftaranPasien) As P2
						From dbo.transaksiPendaftaranPasien xa
							 Inner Join dbo.masterPasien xb On xa.idPasien = xb.idPasien
							 Inner Join dbo.transaksiDiagnosaPasien xc On xa.idPendaftaranPasien = xc.idPendaftaranPasien
							 Inner Join dbo.transaksiDiagnosaPasienDetail xd On xc.idDiagNosa = xd.idDiagnosa
					   Where Convert(date, xa.tglDaftarPasien) Between @periodeAwal And @periodeAkhir And xb.idJenisKelaminPasien = 2/*Perempuan*/
							 And DateDiff(year, xb.tglLahirPasien, xa.tglDaftarPasien) < 1
					Group By xd.idPenyakit) e On a.idPenyakit = e.idPenyakit
		   Left Join (Select xd.idPenyakit, Count(xa.idPendaftaranPasien) As l3
						From dbo.transaksiPendaftaranPasien xa
							 Inner Join dbo.masterPasien xb On xa.idPasien = xb.idPasien
							 Inner Join dbo.transaksiDiagnosaPasien xc On xa.idPendaftaranPasien = xc.idPendaftaranPasien
							 Inner Join dbo.transaksiDiagnosaPasienDetail xd On xc.idDiagNosa = xd.idDiagnosa
					   Where Convert(date, xa.tglDaftarPasien) Between @periodeAwal And @periodeAkhir And xb.idJenisKelaminPasien = 1/*Laki-Laki*/
							 And DateDiff(year, xb.tglLahirPasien, xa.tglDaftarPasien) < 1
					Group By xd.idPenyakit) f On a.idPenyakit = f.idPenyakit
		   Left Join (Select xd.idPenyakit, Count(xa.idPendaftaranPasien) As P3
						From dbo.transaksiPendaftaranPasien xa
							 Inner Join dbo.masterPasien xb On xa.idPasien = xb.idPasien
							 Inner Join dbo.transaksiDiagnosaPasien xc On xa.idPendaftaranPasien = xc.idPendaftaranPasien
							 Inner Join dbo.transaksiDiagnosaPasienDetail xd On xc.idDiagNosa = xd.idDiagnosa
					   Where Convert(date, xa.tglDaftarPasien) Between @periodeAwal And @periodeAkhir And xb.idJenisKelaminPasien = 2/*Perempuan*/
							 And DateDiff(year, xb.tglLahirPasien, xa.tglDaftarPasien) < 1
					Group By xd.idPenyakit) g On a.idPenyakit = g.idPenyakit
		   Left Join (Select xd.idPenyakit, Count(xa.idPendaftaranPasien) As l4
						From dbo.transaksiPendaftaranPasien xa
							 Inner Join dbo.masterPasien xb On xa.idPasien = xb.idPasien
							 Inner Join dbo.transaksiDiagnosaPasien xc On xa.idPendaftaranPasien = xc.idPendaftaranPasien
							 Inner Join dbo.transaksiDiagnosaPasienDetail xd On xc.idDiagNosa = xd.idDiagnosa
					   Where Convert(date, xa.tglDaftarPasien) Between @periodeAwal And @periodeAkhir And xb.idJenisKelaminPasien = 1/*Laki-Laki*/
							 And DateDiff(year, xb.tglLahirPasien, xa.tglDaftarPasien) < 1
					Group By xd.idPenyakit) h On a.idPenyakit = h.idPenyakit
		   Left Join (Select xd.idPenyakit, Count(xa.idPendaftaranPasien) As P4
						From dbo.transaksiPendaftaranPasien xa
							 Inner Join dbo.masterPasien xb On xa.idPasien = xb.idPasien
							 Inner Join dbo.transaksiDiagnosaPasien xc On xa.idPendaftaranPasien = xc.idPendaftaranPasien
							 Inner Join dbo.transaksiDiagnosaPasienDetail xd On xc.idDiagNosa = xd.idDiagnosa
					   Where Convert(date, xa.tglDaftarPasien) Between @periodeAwal And @periodeAkhir And xb.idJenisKelaminPasien = 2/*Perempuan*/
							 And DateDiff(year, xb.tglLahirPasien, xa.tglDaftarPasien) < 1
					Group By xd.idPenyakit) i On a.idPenyakit = i.idPenyakit
		   Left Join (Select xd.idPenyakit, Count(xa.idPendaftaranPasien) As l5
						From dbo.transaksiPendaftaranPasien xa
							 Inner Join dbo.masterPasien xb On xa.idPasien = xb.idPasien
							 Inner Join dbo.transaksiDiagnosaPasien xc On xa.idPendaftaranPasien = xc.idPendaftaranPasien
							 Inner Join dbo.transaksiDiagnosaPasienDetail xd On xc.idDiagNosa = xd.idDiagnosa
					   Where Convert(date, xa.tglDaftarPasien) Between @periodeAwal And @periodeAkhir And xb.idJenisKelaminPasien = 1/*Laki-Laki*/
							 And DateDiff(year, xb.tglLahirPasien, xa.tglDaftarPasien) < 1
					Group By xd.idPenyakit) j On a.idPenyakit = j.idPenyakit
		   Left Join (Select xd.idPenyakit, Count(xa.idPendaftaranPasien) As P5
						From dbo.transaksiPendaftaranPasien xa
							 Inner Join dbo.masterPasien xb On xa.idPasien = xb.idPasien
							 Inner Join dbo.transaksiDiagnosaPasien xc On xa.idPendaftaranPasien = xc.idPendaftaranPasien
							 Inner Join dbo.transaksiDiagnosaPasienDetail xd On xc.idDiagNosa = xd.idDiagnosa
					   Where Convert(date, xa.tglDaftarPasien) Between @periodeAwal And @periodeAkhir And xb.idJenisKelaminPasien = 2/*Perempuan*/
							 And DateDiff(year, xb.tglLahirPasien, xa.tglDaftarPasien) < 1
					Group By xd.idPenyakit) k On a.idPenyakit = k.idPenyakit
		   Left Join (Select xd.idPenyakit, Count(xa.idPendaftaranPasien) As l6
						From dbo.transaksiPendaftaranPasien xa
							 Inner Join dbo.masterPasien xb On xa.idPasien = xb.idPasien
							 Inner Join dbo.transaksiDiagnosaPasien xc On xa.idPendaftaranPasien = xc.idPendaftaranPasien
							 Inner Join dbo.transaksiDiagnosaPasienDetail xd On xc.idDiagNosa = xd.idDiagnosa
					   Where Convert(date, xa.tglDaftarPasien) Between @periodeAwal And @periodeAkhir And xb.idJenisKelaminPasien = 1/*Laki-Laki*/
							 And DateDiff(year, xb.tglLahirPasien, xa.tglDaftarPasien) < 1
					Group By xd.idPenyakit) l On a.idPenyakit = l.idPenyakit
		   Left Join (Select xd.idPenyakit, Count(xa.idPendaftaranPasien) As P6
						From dbo.transaksiPendaftaranPasien xa
							 Inner Join dbo.masterPasien xb On xa.idPasien = xb.idPasien
							 Inner Join dbo.transaksiDiagnosaPasien xc On xa.idPendaftaranPasien = xc.idPendaftaranPasien
							 Inner Join dbo.transaksiDiagnosaPasienDetail xd On xc.idDiagNosa = xd.idDiagnosa
					   Where Convert(date, xa.tglDaftarPasien) Between @periodeAwal And @periodeAkhir And xb.idJenisKelaminPasien = 2/*Perempuan*/
							 And DateDiff(year, xb.tglLahirPasien, xa.tglDaftarPasien) < 1
					Group By xd.idPenyakit) m On a.idPenyakit = m.idPenyakit
		   Left Join (Select xd.idPenyakit, Count(xa.idPendaftaranPasien) As l7
						From dbo.transaksiPendaftaranPasien xa
							 Inner Join dbo.masterPasien xb On xa.idPasien = xb.idPasien
							 Inner Join dbo.transaksiDiagnosaPasien xc On xa.idPendaftaranPasien = xc.idPendaftaranPasien
							 Inner Join dbo.transaksiDiagnosaPasienDetail xd On xc.idDiagNosa = xd.idDiagnosa
					   Where Convert(date, xa.tglDaftarPasien) Between @periodeAwal And @periodeAkhir And xb.idJenisKelaminPasien = 1/*Laki-Laki*/
							 And DateDiff(year, xb.tglLahirPasien, xa.tglDaftarPasien) < 1
					Group By xd.idPenyakit) n On a.idPenyakit = n.idPenyakit
		   Left Join (Select xd.idPenyakit, Count(xa.idPendaftaranPasien) As P7
						From dbo.transaksiPendaftaranPasien xa
							 Inner Join dbo.masterPasien xb On xa.idPasien = xb.idPasien
							 Inner Join dbo.transaksiDiagnosaPasien xc On xa.idPendaftaranPasien = xc.idPendaftaranPasien
							 Inner Join dbo.transaksiDiagnosaPasienDetail xd On xc.idDiagNosa = xd.idDiagnosa
					   Where Convert(date, xa.tglDaftarPasien) Between @periodeAwal And @periodeAkhir And xb.idJenisKelaminPasien = 2/*Perempuan*/
							 And DateDiff(year, xb.tglLahirPasien, xa.tglDaftarPasien) < 1
					Group By xd.idPenyakit) o On a.idPenyakit = o.idPenyakit																						
  ORDER BY a.namaPenyakit
END