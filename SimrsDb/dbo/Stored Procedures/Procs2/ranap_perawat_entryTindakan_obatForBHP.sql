-- =============================================
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Untuk Penjualan E-Resep
-- =============================================
create PROCEDURE [dbo].[ranap_perawat_entryTindakan_obatForBHP]
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT ca.idObatDetail, dbo.namaBarangFarmasi(c.idObatDosis) As namaObat             
		  ,ca.kodeBatch, ca.tglExpired, ca.stok, b.namaSatuanObat
	  FROM dbo.farmasiMasterObat a                                                                 
		   Inner Join dbo.farmasiMasterSatuanObat b On a.idSatuanObat = b.idSatuanObat                
		   Inner Join dbo.farmasiMasterObatDosis c On a.idObat = c.idObat              
				Inner Join dbo.farmasiMasterObatDetail ca On c.idObatDosis = ca.idObatDosis                       
	 WHERE ca.stok >= 1 And ca.idRuangan = @idRuangan
  ORDER BY a.namaObat, c.dosis
END