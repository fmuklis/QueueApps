-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[calculator_umur]
(	
	-- Add the parameters for the function here
	@tanggalLahir date,
	@tanggalDaftar date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	WITH dataSrc AS(
			SELECT CASE 
						WHEN DATEDIFF(HOUR, @tanggalLahir, @tanggalDaftar) / 168 = 0
							 THEN DATEDIFF(HOUR, @tanggalLahir, @tanggalDaftar) / 24
						WHEN DATEDIFF(HOUR, @tanggalLahir, @tanggalDaftar) / 730 = 0 
							 THEN DATEDIFF(HOUR, @tanggalLahir, @tanggalDaftar) / 168
						WHEN DATEDIFF(HOUR, @tanggalLahir, @tanggalDaftar) / 8766 = 0 
							 THEN DATEDIFF(HOUR, @tanggalLahir, @tanggalDaftar) / 730
						ELSE DATEDIFF(HOUR, @tanggalLahir, @tanggalDaftar) / 8766
					END AS umur
				   ,CASE 
						WHEN DATEDIFF(HOUR, @tanggalLahir, @tanggalDaftar) / 168 = 0
							 THEN 'Hari'
						WHEN DATEDIFF(HOUR, @tanggalLahir, @tanggalDaftar) / 730 = 0 
							 THEN 'Minggu'
						WHEN DATEDIFF(HOUR, @tanggalLahir, @tanggalDaftar) / 8766 = 0 
							 THEN 'Bulan'
						ELSE 'Tahun'
					END AS satuanUmur)
	SELECT umur, satuanUmur, detailUmur = CAST(umur AS varchar(50)) +' '+ satuanUmur
	  FROM dataSrc
)