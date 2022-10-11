-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_searchByNama]
	-- Add the parameters for the stored procedure here
	@namaPasien varchar(100)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if exists(Select 1 from masterPasien a where /*a.tglLahirPasien = @tglLahirPasien and*/ namaLengkapPasien like '%' + @namaPasien + '%')
	Begin
		SELECT 'Data ditemukan' as respon,1 as responCode,a.*,b.namaJenisKelamin
		,c.namaDesaKelurahan,c.idKecamatan,d.namaKecamatan,d.idKabupaten
		,e.namaKabupaten,e.idProvinsi,f.namaProvinsi,f.idNegara,g.namaNegara
		,h.namaAgama,i.namaPekerjaan,j.namaPendidikan,k.namaWargaNegara,l.namaStatusPerkawinan 	 
		,Case
			When a.namaAyahPasien = '-' Or Len(Trim(a.tempatLahirPasien)) < 3
				 Then 1
			Else 0
		End As flagUpdate
		,DATEDIFF(hour,tglLahirPasien,GETDATE())/8766 AS Umur 
		from masterPasien a 
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
		where a.namaLengkapPasien like '%' + @namaPasien + '%';
	End
	else
	Begin
		Select 'Data tidak ditemukan' as respon, 0 as responCode;
	End
END