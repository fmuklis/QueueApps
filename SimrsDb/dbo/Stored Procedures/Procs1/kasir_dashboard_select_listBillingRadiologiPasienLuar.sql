
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[kasir_dashboard_select_listBillingRadiologiPasienLuar]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
			
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idBilling, a.idPasienLuar, bb.namaRuangan, ba.namaPasien, ba.namaJenisKelamin, ba.tglLahir, ba.umur
		  ,ba.tlp, ba.alamatPasien, ba.DPJP
		  ,Sum(cb.jmlTarif) + IsNull(Sum(cc.jmlTarifBHP), 0) - IsNull(a.diskonTunai, 0) - ((Sum(cb.jmlTarif) + IsNull(Sum(cc.jmlTarifBHP), 0) - IsNull(a.diskonTunai, 0)) * IsNull(a.diskonPersen, 0) / 100) As nilaiBayar
		  ,Case
				When a.idJenisBayar Is Null
					 Then 1
				Else 0
			End As btnBayar
		  ,Case
				When a.idJenisBayar Is Not Null
					 Then 1
				Else 0
			End As btnCetak
		  ,Case
				When a.idJenisBayar Is Not Null And Cast(a.tglBayar As date) = Cast(GetDate() As date)
					 Then 1
				Else 0
			End As btnBatalBayar
	  FROM dbo.transaksiBillingHeader a
		   Inner Join dbo.transaksiOrder b On a.idOrder = b.idOrder And a.idPasienLuar = b.idPasienLuar
				Outer Apply dbo.getInfo_dataPasienLuar(a.idPasienLuar, b.tglOrder) ba
				Inner Join dbo.masterRuangan bb On b.idRuanganTujuan = bb.idRuangan
		   Inner Join dbo.transaksiOrderDetail c On a.idOrder = c.idOrder
				Inner Join dbo.transaksiTindakanPasien ca On c.idOrderDetail = ca.idOrderDetail
				Cross Apply dbo.getInfo_tarifTindakan(ca.idTindakanPasien) cb
				Outer Apply dbo.getInfo_bhpTindakan(ca.idTindakanPasien) cc
	 WHERE a.idJenisBilling = 4/*Billing Radiologi*/ And (a.idJenisBayar Is Null Or Convert(date, a.tglBayar) = Convert(date, GetDate()))
  GROUP BY a.idBilling, a.idPasienLuar, bb.namaRuangan, ba.namaPasien, ba.namaJenisKelamin, ba.tglLahir, ba.umur
		  ,ba.tlp, ba.alamatPasien, ba.DPJP, a.diskonTunai, a.diskonPersen, a.idJenisBayar, a.tglBayar
END