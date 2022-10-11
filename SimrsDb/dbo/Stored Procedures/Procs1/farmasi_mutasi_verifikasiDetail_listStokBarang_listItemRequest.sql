-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE farmasi_mutasi_verifikasiDetail_listStokBarang_listItemRequest
	-- Add the parameters for the stored procedure here
	@idMutasi bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idItemOrderMutasi, b.namaBarang, a.sisaStok, a.jumlahOrder, a.jumlahOrder - SUM(ISNULL(c.jumlahDisetujui, 0)) AS sisaTebus, b.namaSatuanObat
		  ,CASE
				WHEN a.jumlahOrder > SUM(ISNULL(c.jumlahDisetujui, 0))
					 THEN 1
				ELSE 0
			END AS btnPilih
	  FROM dbo.farmasiMutasiOrderItem a
		   OUTER APPLY dbo.getInfo_barangFarmasi(a.idObatDosis) b
		   LEFT JOIN dbo.farmasiMutasiRequestApproved c ON a.idItemOrderMutasi = c.idItemOrderMutasi
	 WHERE a.idMutasi = @idMutasi
  GROUP BY a.idItemOrderMutasi, b.namaBarang, a.sisaStok, a.jumlahOrder, b.namaSatuanObat
END