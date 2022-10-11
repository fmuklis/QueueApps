-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_searchByKodePasien]
	-- Add the parameters for the stored procedure here
	 @kodePasien varchar(50)

AS
BEGIN	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if exists(Select 1 from masterPasien a where a.kodePasien = replace(@kodePasien,'.',''))
		Begin
			SELECT 'Data ditemukan' as respon,1 as responCode, *
					,n.umur as Umur
					,n.namaPasien, n.namaJenisKelamin as jenisKelamin, n.alamatPasien
					,case dbo.jumlahKata(a.namaLengkapPasien)
					when 1 then n.namaPasien
					else a.namaLengkapPasien
					end as namaDiGelang
					,Case
						When a.namaAyahPasien = '-' OR a.kodePasien > dbo.generate_nomorRekamMedis()
							then 1
							else 0
					 End as flagUpdate
			  FROM masterPasien a 
					outer apply dbo.getInfo_dataPasien(a.idPasien) n
			  WHERE a.kodePasien = replace(@kodePasien,'.','');
		End
	else
		Begin
			Select 'Data tidak ditemukan' as respon, 0 as responCode;
		End
END