-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_returResepDetail_listItemResep]
	-- Add the parameters for the stored procedure here
	@idResep bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.idPenjualanDetail, bc.idReturDetail AS idRetur, bb.namaBarang AS namaObat, ba.kodeBatch
		  ,b.jumlah, bb.namaSatuanObat, bc.jumlahRetur
		  ,CASE
				WHEN bc.idReturDetail Is Null
					 THEN 1
				ELSE 0
			END AS btnAdd
		  ,CASE
				WHEN bc.valid = 0
					 THEN 1
				ELSE 0
			END AS btnEdit
		  ,CASE
				WHEN bc.valid = 0
					 THEN 1
				ELSE 0
			END AS btnHapus
	  FROM dbo.farmasiResepDetail a
		   INNER JOIN dbo.farmasiPenjualanDetail b ON a.idResepDetail = b.idResepDetail
				INNER JOIN dbo.farmasiMasterObatDetail ba ON b.idObatDetail = ba.idObatDetail
				OUTER APPLY dbo.getInfo_barangFarmasi(ba.idObatDosis) bb
				LEFT JOIN dbo.farmasiReturDetail bc ON b.idPenjualanDetail = bc.idPenjualanDetail
	 WHERE a.idResep = @idResep
END