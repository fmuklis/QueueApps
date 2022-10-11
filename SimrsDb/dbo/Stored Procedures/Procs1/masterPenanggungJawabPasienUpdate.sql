-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterPenanggungJawabPasienUpdate]
	-- Add the parameters for the stored procedure here
	 @idPenanggungJawabPasien int
	,@idHubunganKeluarga int
	,@namaPenanggungJawabPasien nvarchar(50)
	,@alamatPenanggungJawabPasien nvarchar(225)
	,@idDokumenIdentitas int
	,@noIdentitasPenanggungJawabPasien nvarchar(20)
	,@idJenisKelaminPenanggungJawabPasien int
	,@idPekerjaanPenanggungJawabPasien int
	,@noHpPenanggungJawabPasien1 nvarchar(50)
	,@noHpPenanggungJawabPasien2 nvarchar(50)
	,@namaPerusahaan nvarchar(50)
	,@alamatPerusahaan nvarchar(50)
	,@noTeleponPerusahaan nvarchar(50)
	,@namaPengantarPasien nvarchar(50)
	,@alamatPengantarPasien nvarchar(220)
	,@noTeleponPengantarPasien nvarchar(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (SELECT 1 from [dbo].[masterPenanggungJawabPasien] where [idPenanggungJawabPasien] = @idPenanggungJawabPasien)
		BEGIN
			UPDATE [dbo].[masterPenanggungJawabPasien]
			   SET [idHubunganKeluarga] = @idHubunganKeluarga 
				  ,[namaPenanggungJawabPasien] = @namaPenanggungJawabPasien 
				  ,[alamatPenanggungJawabPasien] = @alamatPenanggungJawabPasien 
				  ,[idDokumenIdentitas] = @idDokumenIdentitas 
				  ,[noIdentitasPenanggungJawabPasien] = @noIdentitasPenanggungJawabPasien 
				  ,[idJenisKelaminPenanggungJawabPasien] = @idJenisKelaminPenanggungJawabPasien 
				  ,[idPekerjaanPenanggungJawabPasien] = @idPekerjaanPenanggungJawabPasien 
				  ,[noHpPenanggungJawabPasien1] = @noHpPenanggungJawabPasien1 
				  ,[noHpPenanggungJawabPasien2] = @noHpPenanggungJawabPasien2 
				  ,[namaPerusahaan] = @namaPerusahaan 
				  ,[alamatPerusahaan] = @alamatPerusahaan 
				  ,[noTeleponPerusahaan] = @noTeleponPerusahaan 
				  ,[namaPengantarPasien] = @namaPengantarPasien 
				  ,[alamatPengantarPasien] = @alamatPengantarPasien 
				  ,[noTeleponPengantarPasien] = @noTeleponPengantarPasien 
			 WHERE [idPenanggungJawabPasien] = @idPenanggungJawabPasien;
			SELECT 'Data Berhasil Diubah' as respon, 1 as responCode;
		END
	ELSE
		BEGIN
			SELECT 'Maaf Data Tidak Ditemukan' as respon, 0 as responCode;
		END
END