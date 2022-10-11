-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_titipInap_searchByKodePasien]
	-- Add the parameters for the stored procedure here
	 @kodePasien nchar(6)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if exists(Select 1 from masterPasien a where a.kodePasien = @kodePasien)
		Begin
			SELECT 'Data ditemukan' as respon,1 as responCode, *
					,n.umur as Umur
					,a.namaLengkapPasien AS  namaPasien, b.namaJenisKelamin AS jenisKelamin, a.alamatPasien
					,case dbo.jumlahKata(a.namaLengkapPasien)
					when 1 then a.namaLengkapPasien
					else a.namaLengkapPasien
					end as namaDiGelang
					,Case
						When a.namaAyahPasien = '-' OR a.kodePasien > dbo.generate_nomorRekamMedis()
							then 1
							else 0
					 End as flagUpdate
			  FROM masterPasien a 
					inner join masterJenisKelamin b on a.idJenisKelaminPasien = b.idJenisKelamin
					inner join masterDesaKelurahan c on a.idDesaKelurahanPasien = c.idDesaKelurahan
					inner join masterKecamatan d on c.idKecamatan = d.idKecamatan
					inner join masterKabupaten e on d.idKabupaten = e.idKabupaten
					inner join masterProvinsi f on e.idProvinsi = f.idProvinsi
					inner join masterNegara g on f.idNegara = g.idNegara
					inner join masterAgama h on a.idAgamaPasien = h.idAgama
					inner join masterPekerjaan i on a.idPekerjaanPasien = i.idPekerjaan
					inner join masterPendidikan j on a.idPendidikanPasien = j.idPendidikan
					inner join masterWargaNegara k on a.idWargaNegaraPasien = k.idWargaNegara
					inner join masterStatusPerkawinan l on a.idStatusPerkawinanPasien = l.idStatusPerkawinan
					inner join [dbo].[masterDokumenIdentitas] m on a.[idDokumenIdentitasPasien] = m.[idDokumenIdentitas]
					outer apply dbo.calculator_umur(a.tglLahirPasien, GETDATE()) n
			  WHERE a.kodePasien = @kodePasien;
		End
	else
		Begin
			Select 'Data tidak ditemukan' as respon, 0 as responCode;
		End
END