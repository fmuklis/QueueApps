-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Daftar Pasien Order Pemeriksaan
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_dashboard_select_listOrder]
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idOrder, a.tglOrder, ba.noRM, ba.namaPasien, ba.tglLahirPasien, ba.umur, c.Alias
		  ,Case
				When a.idStatusOrder = 1
					 Then 1
				Else 0
			End As btnTerima
		  ,Case
				When a.idStatusOrder = 1
					 Then 1
				Else 0
			End As btnBatal
		  ,Case
				When a.idStatusOrder = 10
					 Then 1
				Else 0
			End As btnKembaliProses
	  FROM dbo.transaksiOrder a
		   Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				Outer Apply dbo.getinfo_datapasien(b.idPasien) ba
		   Inner Join dbo.masterRuangan c On a.idRuanganAsal = c.idRuangan
	 WHERE a.idRuanganTujuan = @idRuangan And (a.idStatusOrder = 1 Or (a.idStatusOrder = 10 And Cast(a.tanggalModifikasi As date) = Cast(getDate() As date)))
  ORDER BY a.tglOrder;
END