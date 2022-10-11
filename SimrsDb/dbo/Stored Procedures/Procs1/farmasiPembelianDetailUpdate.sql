-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Untuk Update Jumlah Pembelian Obat Farmasi Dan Master Obat
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiPembelianDetailUpdate]
	-- Add the parameters for the stored procedure here
	 @idPembelianHeader int
	,@idObat int
	,@jumlahBeli decimal
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	/*DECLARE @jumlahBelix decimal
		Select @jumlahBelix = jumlahBeli From farmasiPembelianDetail Where idObat = @idObat;*/
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*If Exists (Select 1 From dbo.[farmasiPembelianDetail] Where idPembelianHeader = @idPembelianHeader And idObat = @idObat)
		Begin
			Begin Try
				Begin Tran farmasiPembelianUpdate41147;
				--Mengurangi Stok Obat Existing
				UPDATE [dbo].[farmasiMasterObat]
				   SET [StokObat] = StokObat - @jumlahBelix
				 WHERE idObat = @idObat;

				UPDATE [dbo].[farmasiPembelianDetail]
				   SET jumlahBeli = @jumlahBeli
				 WHERE idPembelianHeader = @idPembelianHeader And idObat = @idObat;

				UPDATE [dbo].[farmasiMasterObat]
				   SET [StokObat] = StokObat + @jumlahBeli
				 WHERE idObat = @idObat;
				 Commit Tran farmasiPembelianUpdate41147;
				Select 'Data Berhasil Diupdate' as respon, 1 as responCode;
			End Try
			Begin Catch
				Rollback Tran farmasiPembelianUpdate41147;
				Select 'Error !' + ERROR_MESSAGE() as respon, 0 as responCode;
			End Catch
		End
	Else
		Begin
			Select 'Data Tidak Ditemukan' as respon, 0 as responCode;
		End*/
END