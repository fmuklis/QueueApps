-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[generate_namaPasien]
(	
	-- Add the parameters for the function here
	@tanggalLahir date,
	@tanggalDaftar date,
	@idJenisKelaminPasien tinyint,
	@idStatusPerkawinanPasien tinyint,
	@namaPasien nvarchar(500),
	@namaAyah nvarchar(500)
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT CASE 
				WHEN @idJenisKelaminPasien = 2 AND @idStatusPerkawinanPasien IN(2,3,5)
					 THEN 'Ny. '+ @namaPasien + ' BINTI ' + @namaAyah
				WHEN @idJenisKelaminPasien = 2 AND @idStatusPerkawinanPasien  = 1 AND DATEDIFF(HOUR, @tanggalLahir, @tanggalDaftar) <= 720 
					 THEN 'By. Ny. '+ @namaPasien + ' BINTI ' + @namaAyah
				WHEN @idJenisKelaminPasien = 2 AND @idStatusPerkawinanPasien  = 1 AND DATEDIFF(DAY, @tanggalLahir, @tanggalDaftar) BETWEEN 30 AND 6204 
					 THEN 'An. '+ @namaPasien + ' BINTI ' + @namaAyah
				WHEN @idJenisKelaminPasien = 2 AND @idStatusPerkawinanPasien  = 1 AND DATEDIFF(DAY, @tanggalLahir, @tanggalDaftar) > 6204 
					 THEN 'Nn. '+ @namaPasien + ' BINTI ' + @namaAyah
				WHEN @idJenisKelaminPasien = 1 AND @idStatusPerkawinanPasien IN(2,3,5) 
					 THEN 'Tn. '+ @namaPasien + ' BIN ' + @namaAyah
				WHEN @idJenisKelaminPasien = 1 AND @idStatusPerkawinanPasien  = 1 AND DATEDIFF(HOUR, @tanggalLahir, @tanggalDaftar) <= 720 
					 THEN 'By. Ny. '+ @namaPasien + ' BIN ' + @namaAyah
				WHEN @idJenisKelaminPasien = 1 AND @idStatusPerkawinanPasien  = 1 AND DATEDIFF(DAY, @tanggalLahir, @tanggalDaftar) BETWEEN 30 AND 6204 
					 THEN 'An. '+ @namaPasien + ' BIN ' + @namaAyah
				WHEN @idJenisKelaminPasien = 1 AND @idStatusPerkawinanPasien  = 1 AND DATEDIFF(DAY, @tanggalLahir, @tanggalDaftar) > 6204
					 THEN 'Tn. '+ @namaPasien + ' BIN ' + @namaAyah
			END AS namaPasien
)