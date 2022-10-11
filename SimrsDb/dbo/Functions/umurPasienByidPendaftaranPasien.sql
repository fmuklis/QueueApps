-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[umurPasienByidPendaftaranPasien]
(
	-- Add the parameters for the function here
	@idPendaftaranPasien int
)
RETURNS nvarchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result nvarchar(50)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = Case 
						  When DATEDIFF(hour, b.tglLahirPasien, a.tglDaftarPasien) / 168 = 0
							   Then Convert(nvarchar(50), DATEDIFF(hour, b.tglLahirPasien, a.tglDaftarPasien) / 24) + ' Hari'
						  When DATEDIFF(hour, b.tglLahirPasien, a.tglDaftarPasien) / 730 = 0 
							   Then Convert(nvarchar(50),  DATEDIFF(hour,b.tglLahirPasien, a.tglDaftarPasien) /168) + ' Minggu'
						  When DATEDIFF(hour, b.tglLahirPasien, a.tglDaftarPasien) / 8766 = 0 
							   Then Convert(nvarchar(50), DATEDIFF(hour,b.tglLahirPasien, a.tglDaftarPasien) / 730) + ' Bulan'
						  Else Convert(nvarchar(50), DATEDIFF(hour, b.tglLahirPasien, a.tglDaftarPasien) /8766) + ' Tahun'
					  End
	  FROM dbo.transaksiPendaftaranPasien a
		   Inner Join dbo.masterPasien b On a.idPasien = b.idPasien
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
	-- Return the result of the function
	RETURN @Result
END