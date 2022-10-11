﻿
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_dashboard_listBillingLaboratoriumPasienLuar]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.		
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idBilling, a.idPasienLuar, bb.namaRuangan, ba.namaPasien, ba.namaJenisKelamin, ba.tglLahir, ba.umur
		  ,ba.tlp, ba.alamatPasien, ba.DPJP
		  ,dbo.calculator_totalTagihanLaboratorium(a.idBilling) AS nilaiBayar
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
		   INNER JOIN dbo.transaksiOrder b ON a.idOrder = b.idOrder AND a.idPasienLuar = b.idPasienLuar
				OUTER APPLY dbo.getInfo_dataPasienLuar(a.idPasienLuar, b.tglOrder) ba
				LEFT JOIN dbo.masterRuangan bb ON b.idRuanganTujuan = bb.idRuangan
	 WHERE a.idJenisBilling = 2/*Billing Lab*/ And (a.idJenisBayar Is Null Or Convert(date, a.tglBayar) = Convert(date, GetDate()))
END