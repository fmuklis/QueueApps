-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[getInfo_biayaBHP]
(
	-- Add the parameters for the function here
	@idTindakanPasien int
)
RETURNS TABLE
AS
RETURN
(
	-- Add the SELECT statement with parameter references here
	SELECT a.idTindakanPasien AS idTindakanBHP, ba.namaBarang As namaBHP, a.hargaJual As tarifBHP, a.jumlah As jumlahBHP, ba.namaSatuanObat As satuanBHP
		  ,Case
				When a.flagPaket = 1
					 Then 0
				Else a.hargaJual * a.jumlah
			End As jumlahTarifBHP
		  ,Case
				When a.flagPaket = 1
					 Then 0
				Else 1
			End As penagihanBHP
		  ,Case
				When a.flagPaket = 1
					 Then 'Paket/Tdk Ditagih'
				Else 'Ditagih'
			End As statusBHP
	  FROM dbo.farmasiPenjualanDetail a
		   INNER JOIN dbo.farmasiMasterObatDetail b On a.idObatDetail = b.idObatDetail
				OUTER APPLY dbo.getdata_barangfarmasi(b.idObatDosis) ba
	 WHERE a.idTindakanPasien = @idTindakanPasien
)