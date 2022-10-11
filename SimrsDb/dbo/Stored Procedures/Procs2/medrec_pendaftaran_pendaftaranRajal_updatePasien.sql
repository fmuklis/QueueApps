-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_updatePasien] 
	-- Add the parameters for the stored procedure here
	 @idPasien int
	,@kodePasien nchar(6)
	,@namaLengkapPasien nvarchar(100)
	,@gelarDepanPasien nvarchar(50)
	,@gelarBelakangPasien nvarchar(50)
	,@idPekerjaanPasien int
	,@tempatLahirPasien nvarchar(50)
	,@tglLahirPasien date
	,@idJenisKelaminPasien int
	,@alamatPasien nvarchar(250)
	,@idDesaKelurahanPasien int
	,@namaAyahPasien nvarchar(50)
	,@namaIbuPasien nvarchar(50)
	,@anakKePasien int
	,@idDokumenIdentitasPasien int
	,@noDokumenIdentitasPasien nvarchar(50)
	,@idPendidikanPasien int
	,@idAgamaPasien int
	,@idWargaNegaraPasien int
	,@noHpPasien1 nvarchar(50)
	,@noHPPasien2 nvarchar(50)
	,@idStatusPerkawinanPasien int
	,@catatanKesehatan nvarchar(max)
	,@noBPJS varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If LEN(@kodePasien)<6
	Begin
		select 'Jumlah digit No.RM tidak boleh kurang dari enam digit' as respon, 0 as responCode;
	End
	else
	If LEN(@kodePasien)>6
	Begin
		select 'Jumlah digit No.RM tidak boleh lebih dari enam digit' as respon, 0 as responCode;
	End
	else
	if exists(Select 1 from masterPasien where kodePasien = @kodePasien and idPasien! = @idPasien)
	Begin
		select 'No.RM ini ' + @kodePasien + ' sudah digunakan dipasien lain' as respon, 0 as responCode;
	End
	else
	if exists (select 1 from masterPasien where idPasien = @idPasien) 
	BEGIN
	UPDATE [dbo].[masterPasien]
	   SET 	kodePasien = @kodePasien
			,[namaLengkapPasien] = @namaLengkapPasien
			,[gelarDepanPasien] = @gelarDepanPasien
			,[gelarBelakangPasien] = @gelarBelakangPasien
			,[idPekerjaanPasien] = @idPekerjaanPasien
			,[tempatLahirPasien] = @tempatLahirPasien
			,[tglLahirPasien] = @tglLahirPasien
			,[idJenisKelaminPasien] = @idJenisKelaminPasien
			,[alamatPasien] = @alamatPasien
			,[idDesaKelurahanPasien] = @idDesaKelurahanPasien
			,[namaAyahPasien] = @namaAyahPasien
			,[namaIbuPasien] = @namaIbuPasien
			,[anakKePasien] = @anakKePasien
			,[idDokumenIdentitasPasien] = @idDokumenIdentitasPasien
			,[noDokumenIdentitasPasien] = @noDokumenIdentitasPasien
			,[idPendidikanPasien] = @idPendidikanPasien
			,[idAgamaPasien] = @idAgamaPasien
			,[idWargaNegaraPasien] = @idWargaNegaraPasien
			,[noHpPasien1] = @noHpPasien1
			,[noHPPasien2] = @noHPPasien2
			,[idStatusPerkawinanPasien] = @idStatusPerkawinanPasien
			,[catatanKesehatan] = @catatanKesehatan
			,[noBPJS] = @noBPJS
	 WHERE idPasien = @idPasien;
	 select 'Data Berhasil Diupdate' as respon, 1 as responCode,@kodePasien as kodePasien;
	END
else
	begin
		select 'Data Tidak Ditemukan' as respon, 0 as responCode;
	end
END