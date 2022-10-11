-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterObatDosisDelete] 
	-- Add the parameters for the stored procedure here
	@idObatDosis int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.farmasiMasterObatDetail Where idObatDosis = @idObatDosis)
		Begin
			Select 'Gagal!: Barang Farmasi Telah Memiliki Stok, Tidak Dapat Dihapus' As respon, 0 As responCode;
		End
	Else
		Begin Try
			DELETE [dbo].[farmasiMasterObatDosis]
			 WHERE idObatDosis = @idObatDosis;
			 Select 'Data Barang Farmasi Berhasil Dihapus' As respon, 1 As responCode;
		End Try
		Begin Catch
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch
END