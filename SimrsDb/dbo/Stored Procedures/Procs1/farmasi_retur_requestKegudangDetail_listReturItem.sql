-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_requestKegudangDetail_listReturItem]
	-- Add the parameters for the stored procedure here
	@idRetur bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idReturDetail, ba.namaBarang, b.kodeBatch, b.tglExpired, a.jumlahAsal
		  ,a.jumlahRetur, a.jumlahAsal - a.jumlahRetur AS sisa, ba.namaSatuanObat
	  FROM dbo.farmasiReturDetail a
		   LEFT JOIN dbo.farmasiMasterObatDetail b ON a.idObatDetail = b.idObatDetail
				OUTER APPLY dbo.getInfo_barangFarmasi(b.idObatDosis) ba
	 WHERE a.idRetur = @idRetur
  ORDER BY ba.namaBarang
END