
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[getInfo_biayaKamarRawatInap]
(
	-- Add the parameters for the function here
	@idPendaftaranPasien bigint
)
RETURNS TABLE
AS
RETURN
(
	-- Add the SELECT statement with parameter references here
	SELECT SUM(a.lamaInap) AS totalLamaInap
		  ,SUM(a.lamaInap * CASE 
								 WHEN a.ditagih = 1 
									  THEN tarifKamar 
								 ELSE 0 
							 END) AS totalBiayaKamarRawatInap
	  FROM dbo.transaksiPendaftaranPasienDetail a
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
)