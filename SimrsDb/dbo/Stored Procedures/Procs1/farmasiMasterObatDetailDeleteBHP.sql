-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterObatDetailDeleteBHP]
	-- Add the parameters for the stored procedure here
	@idObatDetail int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @persentaseHargaJual decimal(18,2) = (Select persentaseHargaJualFarmasi From dbo.masterKonfigurasi)
		   ,@idObatDosis int
		   ,@hargaPokok money;
	 Select @idObatDosis = idObatDosis, @hargaPokok = hargaPokok 
	   From dbo.farmasiMasterObatDetail 
	  Where idObatDetail = @idObatDetail;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.farmasiPenjualanDetail Where idObatDetail = @idObatDetail)
		Begin
			Select 'Gagal!: Obat Telah Terjual' As respon, 0 As responCode;
		End
	Else
		Begin Try
			Begin Tran  tranzfarmMastObatDetailDelBHP;
			/*Delete Records*/
			DELETE FROM [dbo].[farmasiMasterObatDetail]
				  WHERE idObatDetail = @idObatDetail;

			/*UPDATE Harga Jual*/
			UPDATE a
			   SET hargaJual = b.hargaPokok + (b.hargaPokok * @persentaseHargaJual / 100)
			  FROM dbo.farmasiMasterObatDosis a
				   Inner Join (Select xa.idObatDosis, Max(xa.hargaPokok) As hargaPokok
								 From dbo.farmasiMasterObatDetail xa
							 Group By xa.idObatDosis) b On a.idObatDosis = b.idObatDosis
			 WHERE a.idObatDosis = @idObatDosis;
			Select 'Data Berhasil Dihapus' As respon, 1 As responCode;
			Commit Tran tranzfarmMastObatDetailDelBHP;
		End Try
		Begin Catch
			Rollback Tran tranzfarmMastObatDetailDelBHP;
			Select 'Error!: ' + ERROR_MESSAGE() As respon, 1 As responCode;
		End Catch
END