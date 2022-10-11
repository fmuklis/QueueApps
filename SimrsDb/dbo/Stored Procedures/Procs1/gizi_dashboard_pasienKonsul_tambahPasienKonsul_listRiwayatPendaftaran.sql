-- =============================================
-- Author:		KOMAR
-- Create date: 22-02-2022
-- Description:	
-- =============================================
CREATE PROCEDURE gizi_dashboard_pasienKonsul_tambahPasienKonsul_listRiwayatPendaftaran
	-- Add the parameters for the stored procedure here
	@kodePasien nchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 SELECT TOP 10 b.idPendaftaranPasien, a.namaLengkapPasien
			,FORMAT(b.tglDaftarPasien, 'dd/MM/yyyy hh:mm:ss') AS tglDaftarPasien, c.namaRuangan
	   FROM dbo.masterPasien a
			INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPasien = b.idPasien
			INNER JOIN dbo.masterRuangan c ON b.idRuangan = c.idRuangan
	  WHERE a.kodePasien = @kodePasien
   ORDER BY b.idPendaftaranPasien DESC
END