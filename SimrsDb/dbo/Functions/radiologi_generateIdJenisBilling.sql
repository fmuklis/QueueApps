-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[radiologi_generateIdJenisBilling]
(
	-- Add the parameters for the function here
	@idOrder bigint
)
RETURNS tinyint
AS
BEGIN
	-- Declare the return variable here
	DECLARE @idJenisBilling tinyint;

	-- Add the T-SQL statements to compute the return value here
	SELECT @idJenisBilling = CASE
								  WHEN b.idJenisPendaftaran IN(1,2)/*IGD,RaJal*/ AND b.idJenisPerawatan = 2/*Rawat Jalan*/ AND ba.idJenisPenjaminInduk = 1/*UMUM*/
									   THEN 4/*Billing Radiologi*/
								  WHEN b.idJenisPendaftaran = 1/*IGD*/ AND b.idJenisPerawatan = 2/*Rawat Jalan*/ AND ba.idJenisPenjaminInduk = 2/*BPJS*/
									   THEN 5/*Billing IGD*/
								  WHEN b.idJenisPendaftaran = 2/*Rawat Jalan*/ AND b.idJenisPerawatan = 2/*Rawat Jalan*/ AND ba.idJenisPenjaminInduk = 2/*BPJS*/
									   THEN 1/*Billing Rawat Jalan*/
								  WHEN b.idJenisPendaftaran IN(1,2)/*IGD,RaJal*/ AND b.idJenisPerawatan = 1/*Rawat Inap*/ AND ba.idJenisPenjaminInduk IN(1,2)/*UMUM,BPJS*/
									   THEN 6/*Billing Rawat Inap*/
							 END
	  FROM dbo.transaksiOrder a
		   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) ba
	 WHERE a.idOrder = @idOrder;

	-- Return the result of the function
	RETURN @idJenisBilling

END