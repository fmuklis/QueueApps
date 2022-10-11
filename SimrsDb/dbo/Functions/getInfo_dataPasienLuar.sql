-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[getInfo_dataPasienLuar]
(	
	-- Add the parameters for the function here
	@idPasienLuar bigint,
	@tglPendaftaran date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT a.nama AS namaPasien, b.namaJenisKelamin, a.tglLahir, c.detailUmur AS umur, a.alamat AS alamatPasien, a.tlp, a.dokter AS DPJP
	  FROM dbo.masterPasienLuar a
		   LEFT JOIN dbo.masterJenisKelamin b ON a.idJenisKelamin = b.idJenisKelamin
		   OUTER APPLY dbo.calculator_umur(a.tglLahir, @tglPendaftaran) c
	 WHERE a.idPasienLuar = @idPasienLuar
)