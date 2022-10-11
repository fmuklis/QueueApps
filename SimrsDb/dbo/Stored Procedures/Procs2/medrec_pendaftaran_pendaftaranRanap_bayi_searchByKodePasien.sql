-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_bayi_searchByKodePasien]
	-- Add the parameters for the stored procedure here
	 @kodePasien nchar(6)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if exists(Select 1 from masterPasien a where a.kodePasien = REPLACE(@kodePasien, '.', ''))
		Begin
			SELECT 'Data ditemukan' as respon,1 as responCode, *
					,b.umur as Umur
					,b.namaPasien, b.namaJenisKelamin, b.alamatPasien
					,case dbo.jumlahKata(a.namaLengkapPasien)
					when 1 then b.namaPasien
					else a.namaLengkapPasien
					end as namaDiGelang
					,Case
						When a.namaAyahPasien = '-' OR a.kodePasien > dbo.generate_nomorRekamMedis()
							then 1
							else 0
					 End as flagUpdate
			  FROM dbo.masterPasien a 
					OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
			  WHERE a.kodePasien = REPLACE(@kodePasien, '.', '');
		End
	else
		Begin
			Select 'Data tidak ditemukan' as respon, 0 as responCode;
		End
END