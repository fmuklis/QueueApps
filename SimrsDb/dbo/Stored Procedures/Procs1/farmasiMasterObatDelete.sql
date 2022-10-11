-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterObatDelete] 
	-- Add the parameters for the stored procedure here
	 @idObat int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists (Select 1 From [dbo].[farmasiMasterObatDosis] a
					  Inner Join dbo.farmasiMasterObatDetail b On a.idObatDosis = b.idObatDetail 
				Where a.idObat = @idObat)
		Begin
			Select 'Gagal!: Barang Memiliki Stok Yang Tidak Dapat Dihapus ' As respon, 0 responCode;
		End
	Else
		Begin
			Delete [dbo].[farmasiMasterObat]
			 WHERE [idObat] = @idObat;
			Select 'Data Berhasil Dihapus' as respon, 1 responCode;
		End
END