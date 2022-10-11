-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterObatSelectPersediaan]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @query  AS NVARCHAR(MAX)
			,@where  AS NVARCHAR(MAX)
			,@cols AS NVARCHAR(MAX) = STUFF((SELECT ',' + QUOTENAME(namaJenisStok) 
										FROM dbo.farmasiMasterObatJenisStok
										ORDER BY idJenisStok
										FOR XML PATH(''), TYPE
										).value('.', 'NVARCHAR(MAX)') 
									,1,1,'');
	SET NOCOUNT ON;

    -- Insert statements for procedure here

SET @query = 'Select * 
				From (SELECT a.idObat
							 ,a.idJenisPenjaminInduk ,e.namaJenisPenjaminInduk
							 ,kodeObat
							 ,namaObat, b.dosis, ba.namaSatuanDosis
							 ,a.idJenisObat, d.namaJenisObat
							 ,a.idSatuanObat ,c.namaSatuanObat
							 ,jumlahHariPeringatanKadaluarsa
							 ,stok
							 ,hargaPokok
							 ,namaJenisStok
						FROM dbo.farmasiMasterObat a
							 Inner Join dbo.farmasiMasterObatDosis b on a.idObat = b.idObat
								Left Join dbo.farmasiMasterObatSatuanDosis ba On b.idSatuanDosis = ba.idSatuanDosis
								Inner Join dbo.farmasiMasterObatDetail bb On b.idObatDosis = bb.idObatDosis
								Inner Join dbo.farmasiMasterObatJenisStok bc On bb.idJenisStok = bc.idJenisStok
							 Inner Join dbo.farmasiMasterSatuanObat c On a.idSatuanObat = c.idSatuanObat
							 Inner Join dbo.farmasiMasterObatJenis d On a.idJenisObat = d.idJenisObat
							 Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk e On a.idJenisPenjaminInduk = e.idJenisPenjaminInduk) As x
			  PIVOT (Sum(stok)
				     For namaJenisStok in ('+@cols+')) p'
--Exec (@query);
	SELECT a.idObat
		  ,a.idJenisPenjaminInduk ,e.namaJenisPenjaminInduk
		  ,kodeObat
		  ,Replace(namaObat +' '+ Replace(Convert(nvarchar(50), b.dosis), '.00', '') +' '+ Replace(bb.namaSatuanDosis, '-', ''), ' 0 ', '') As namaObat
		  ,a.idJenisObat, d.namaJenisObat, b.hargaJual
		  ,a.idSatuanObat ,c.namaSatuanObat
		  ,jumlahHariPeringatanKadaluarsa
		  ,bc.stokGudang, bc.nilaiGudang
		  ,bd.stokApotek, bd.nilaiApotek
		  ,be.stokDepoIGD, be.nilaiDepoIGD
		  ,bf.stokDepoOK, bf.nilaiDepoOK
		  ,bg.stokDepoRaNap, bg.nilaiDepoRaNap
		  ,bh.stokDepoICU, bh.nilaiDepoICU
		  ,bi.stokDepoLab, bi.nilaiDepoLab
		  ,bj.stokDepoRadio, bj.nilaiDepoRadio
		  ,bk.stokDepoRaJal, bk.nilaiDepoRaJal
		  ,IsNull(bc.stokGudang, 0) + IsNull(bd.stokApotek, 0) + IsNull(be.stokDepoIGD, 0) + IsNull(bf.stokDepoOK, 0) + IsNull(bg.stokDepoRaNap, 0) + IsNull(bh.stokDepoICU, 0) + IsNull(bi.stokDepoLab, 0) + IsNull(bj.stokDepoRadio, 0) + IsNull(bk.stokDepoRaJal, 0) As stokJumlah
		  ,IsNull(bc.nilaiGudang, 0) + IsNull(bd.nilaiApotek, 0) + IsNull(be.nilaiDepoIGD, 0) + IsNull(bf.nilaiDepoOK, 0) + IsNull(bg.nilaiDepoRaNap, 0) + IsNull(bh.nilaiDepoICU, 0) + IsNull(bi.nilaiDepoLab, 0) + IsNull(bj.nilaiDepoRadio, 0) + IsNull(bk.nilaiDepoRaJal, 0) As nilaiJumlah
	  FROM dbo.farmasiMasterObat a
		   Inner Join dbo.farmasiMasterObatDosis b on a.idObat = b.idObat
				Inner Join (Select xa.idObatDosis
							  From dbo.farmasiMasterObatDetail xa
							Where IsNull(xa.stok, 0) > 0
						  Group By xa.idObatDosis) ba On b.idObatDosis = ba.idObatDosis
				Inner Join dbo.farmasiMasterObatSatuanDosis bb On b.idSatuanDosis = bb.idSatuanDosis
				Left Join (Select xa.idObatDosis, Sum(xa.stok) As stokGudang, Sum(xa.stok * xa.hargaPokok) As nilaiGudang
							 From dbo.farmasiMasterObatDetail xa
							Where xa.idJenisStok = 1
						 Group By xa.idObatDosis) bc On b.idObatDosis = bc.idObatDosis
				Left Join (Select xa.idObatDosis, Sum(xa.stok) As stokApotek, Sum(xa.stok * xa.hargaPokok) As nilaiApotek
							 From dbo.farmasiMasterObatDetail xa
							Where xa.idJenisStok = 2
						 Group By xa.idObatDosis) bd On b.idObatDosis = bd.idObatDosis
				Left Join (Select xa.idObatDosis, Sum(xa.stok) As stokDepoIGD, Sum(xa.stok * xa.hargaPokok) As nilaiDepoIGD
											  From dbo.farmasiMasterObatDetail xa
							Where xa.idJenisStok = 3
						 Group By xa.idObatDosis) be On b.idObatDosis = be.idObatDosis
				Left Join (Select xa.idObatDosis, Sum(xa.stok) As stokDepoOK, Sum(xa.stok * xa.hargaPokok) As nilaiDepoOK
							 From dbo.farmasiMasterObatDetail xa
							Where xa.idJenisStok = 4
						 Group By xa.idObatDosis) bf On b.idObatDosis = bf.idObatDosis
				Left Join (Select xa.idObatDosis, Sum(xa.stok) As stokDepoRaNap, Sum(xa.stok * xa.hargaPokok) As nilaiDepoRaNap
							 From dbo.farmasiMasterObatDetail xa
							Where xa.idJenisStok = 5
						 Group By xa.idObatDosis) bg On b.idObatDosis = bg.idObatDosis
				Left Join (Select xa.idObatDosis, Sum(xa.stok) As stokDepoICU, Sum(xa.stok * xa.hargaPokok) As nilaiDepoICU
							 From dbo.farmasiMasterObatDetail xa
							Where xa.idJenisStok = 6
						 Group By xa.idObatDosis) bh On b.idObatDosis = bh.idObatDosis
				Left Join (Select xa.idObatDosis, Sum(xa.stok) As stokDepoLab, Sum(xa.stok * xa.hargaPokok) As nilaiDepoLab
							 From dbo.farmasiMasterObatDetail xa
							Where xa.idJenisStok = 7
						 Group By xa.idObatDosis) bi On b.idObatDosis = bi.idObatDosis
				Left Join (Select xa.idObatDosis, Sum(xa.stok) As stokDepoRadio, Sum(xa.stok * xa.hargaPokok) As nilaiDepoRadio
							 From dbo.farmasiMasterObatDetail xa
							Where xa.idJenisStok = 8
						 Group By xa.idObatDosis) bj On b.idObatDosis = bj.idObatDosis
				Left Join (Select xa.idObatDosis, Sum(xa.stok) As stokDepoRaJal, Sum(xa.stok * xa.hargaPokok) As nilaiDepoRaJal
							 From dbo.farmasiMasterObatDetail xa
							Where xa.idJenisStok = 9
						 Group By xa.idObatDosis) bk On b.idObatDosis = bk.idObatDosis
		   Inner Join dbo.farmasiMasterSatuanObat c On a.idSatuanObat = c.idSatuanObat
		   Inner Join dbo.farmasiMasterObatJenis d On a.idJenisObat = d.idJenisObat
		   Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk e On a.idJenisPenjaminInduk = e.idJenisPenjaminInduk
  ORDER BY a.namaObat
END