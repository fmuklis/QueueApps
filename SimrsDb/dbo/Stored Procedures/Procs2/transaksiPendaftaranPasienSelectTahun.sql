CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienSelectTahun]	

AS
BEGIN

	SET NOCOUNT ON;
	Select Distinct(YEAR(tglDaftarPasien)) Tahun
	FROM [dbo].[transaksiPendaftaranPasien]
END