-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[listBarangFarmasiMemasukiBatasMinimal]
	-- Add the parameters for the stored procedure here
	@idUser int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idJenisStok nvarchar(max) = (Select b.idJenisStok From dbo.masterUser a
									   Inner Join dbo.masterRuangan b On a.idRuangan = b.idRuangan
								 Where a.idUser = @idUser)
	Declare @where nvarchar(max) = Case
										When @idJenisStok = 1
											Then 'WHERE a.stokMinimalGudang > = eb.Stok'
										Else 'WHERE a.stokMinimalApotik > = eb.Stok'
								    End;
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 'SELECT a.idObat,e.idobatDosis, e.dosis, e.idSatuanDosis, ea.namaSatuanDosis
				,a.idJenisObat ,c.namaJenisObat, a.stokMinimalApotik, a.stokMinimalGudang
				,a.idSatuanObat ,d.namaSatuanObat, eb.Stok
				,Replace(a.namaObat +'' ''+ Replace(Convert(nvarchar(50), e.dosis), ''.00'', '''') +'' ''+ Replace(ea.namaSatuanDosis, ''-'', ''''), '' 0 '', '''') As namaObat
			FROM dbo.farmasiMasterObat a
				 Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk b On a.idJenisPenjaminInduk = b.idJenisPenjaminInduk
				 Inner Join dbo.farmasiMasterObatJenis c On a.idJenisObat = c.idJenisObat
				 Inner Join dbo.farmasiMasterSatuanObat d On a.idSatuanObat = d.idSatuanObat
				 Inner Join dbo.farmasiMasterObatDosis e on a.idObat = e.idObat
					Inner join dbo.farmasiMasterObatSatuanDosis ea on e.idSatuanDosis = ea.idSatuanDosis
					Inner Join (Select idObatDosis
									  ,Sum(stok) As Stok 
								  From dbo.farmasiMasterObatDetail
								 Where idJenisStok = '+@idJenisStok+'
							  Group By idObatDosis) eb On e.idObatDosis = eb.idObatDosis '+@where+'';

END