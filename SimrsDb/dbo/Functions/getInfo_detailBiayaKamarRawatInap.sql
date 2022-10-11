-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[getInfo_detailBiayaKamarRawatInap]
(
	-- Add the parameters for the function here
	@idPendaftaranPasien bigint
)
RETURNS TABLE
AS
RETURN
(
	-- Add the SELECT statement with parameter references here
	SELECT b.ruanganInap, b.kamarInap, a.tanggalMasuk, a.tanggalKeluar, a.tarifKamar
		  ,COALESCE(a.lamaInap, dbo.calculator_lamaInap(a.tanggalMasuk, COALESCE(a.tanggalKeluar, GETDATE()))) AS lamaInap
		  ,COALESCE(a.lamaInap, dbo.calculator_lamaInap(a.tanggalMasuk, COALESCE(a.tanggalKeluar, GETDATE())))
				* CASE 
					   WHEN a.ditagih = 1/*True*/
							THEN a.tarifKamar 
					   ELSE 0
				   END AS biayaKamarRawatInap
		  ,CASE
				WHEN c.idKelas IN(6,8,9)/*ICU/ ICCU,HCU,ISOLASI*/
					 THEN 13
				ELSE 12
			END AS idMasterTarifGroup
	  FROM dbo.transaksiPendaftaranPasienDetail a
		   OUTER APPLY dbo.getInfo_dataKamarInap(a.idTempatTidur) b
		   INNER JOIN dbo.masterTarifKamar c ON a.idMasterTarifKamar = c.idMasterTarifKamar
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
)