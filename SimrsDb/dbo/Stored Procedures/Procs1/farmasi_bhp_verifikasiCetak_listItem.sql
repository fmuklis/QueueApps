-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[farmasi_bhp_verifikasiCetak_listItem]
	-- Add the parameters for the stored procedure here
	@idMutasi bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT bb.namaBarang, ba.kodeBatch, ba.tglExpired, a.jumlahOrder, b.jumlahDisetujui, bb.namaSatuanObat
	  FROM dbo.farmasiMutasiOrderItem a
		   INNER JOIN dbo.farmasiMutasiRequestApproved b ON a.idItemOrderMutasi = b.idItemOrderMutasi
				LEFT JOIN dbo.farmasiMasterObatDetail ba ON b.idObatDetail = ba.idObatDetail
				OUTER APPLY dbo.getInfo_barangFarmasi(ba.idObatDosis) bb
	 WHERE a.idMutasi = @idMutasi
  ORDER BY bb.namaBarang, tglExpired
END