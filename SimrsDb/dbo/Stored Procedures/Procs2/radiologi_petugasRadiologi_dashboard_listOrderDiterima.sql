-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Daftar Pasien Order Pemeriksaan
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[radiologi_petugasRadiologi_dashboard_listOrderDiterima]
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idOrder, a.tglOrder, bb.penjamin, ba.noRM, ba.namaPasien, ba.tglLahirPasien, ba.umur, c.Alias
		  ,Case
				When a.idStatusOrder = 2
					 Then 1
				Else 0
			End As btnEnrty
		  ,Case
				When a.idStatusOrder = 2
					 Then 1
				Else 0
			End As btnBatalTerima
		  ,Case
				When a.idStatusOrder = 3
					 Then 1
				Else 0
			End As btnBatalValidasi
		  ,/*Case
				When a.idStatusOrder = 3 And (d.idPemeriksaanLab Is Null Or e.notValid = 1)
					 Then 1
				Else 0
			End*/0 As btnEntryHasil
		  ,/*Case
				When f.valid = 1
					 Then 1
				Else 0
			End*/0 As btnCetakHasil
	  FROM dbo.transaksiOrder a
		   Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				Outer Apply dbo.getinfo_datapasien(b.idPasien) ba
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) bb
		   Inner Join dbo.masterRuangan c On a.idRuanganAsal = c.idRuangan
		   Outer Apply (Select Top 1 1 As notValid
						  From dbo.transaksiOrderDetail xa
							   Inner Join dbo.transaksiTindakanPasien xb On xa.idOrderDetail = xb.idOrderDetail
							   Inner Join dbo.transaksiPemeriksaanLaboratorium xc On xb.idTindakanPasien = xc.idTindakanPasien
						 Where xa.idOrder = a.idOrder And xc.valid = 0) e
		   Outer Apply (Select Top 1 1 As valid
						  From dbo.transaksiOrderDetail xa
							   Inner Join dbo.transaksiTindakanPasien xb On xa.idOrderDetail = xb.idOrderDetail
							   Inner Join dbo.transaksiPemeriksaanLaboratorium xc On xb.idTindakanPasien = xc.idTindakanPasien
						 Where xa.idOrder = a.idOrder And xc.valid = 1) f
	 WHERE a.idRuanganTujuan = @idRuangan And (a.idStatusOrder = 2 Or (a.idStatusOrder = 3 And Cast(a.tanggalEntry As date) = Cast(getDate() As date)))/*(a.idStatusOrder In(2,3) Or (a.idStatusOrder = 4 And Cast(a.tglHasil As date) = Cast(getDate() As date)))*/
  ORDER BY a.tglOrder;
END