-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiKonsulSelect]
	-- Add the parameters for the stored procedure here
	@idRuangan int
	,@idStatusKonsul1 int
	,@idStatusKonsul2 int
	,@idStatusPendaftaran int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*SELECT a.idTransaksiKonsul ,a.idStatusKonsul ,a.tglOrderKonsul
		   ,b.idPendaftaranPasien ,b.idStatusPendaftaran ,b.idRuangan ,ba.namaRuangan 
		   ,c.kodePasien ,c.noRM ,c.namaPasien ,c.tglLahirPasien ,c.umur ,c.jenisKelamin
--		   ,e.namaStatusKonsul
	  FROM dbo.transaksiKonsul a
		   Inner Join dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
		   		Inner Join dbo.masterRuangan ba On b.idRuangan = ba.idRuangan
		   Inner Join (Select * From dbo.dataPasien()) c On b.idPasien = c.idPasien			
		   Inner Join dbo.masterStatusKonsul d on a.idStatusKonsul = d.idStatusKonsul
	 WHERE a.idRuanganTujuan = @idRuangan --And a.idStatusKonsul --Between @idStatusKonsul1 And @idStatusKonsul2
		   And b.idStatusPendaftaran = @idStatusPendaftaran;*/

END