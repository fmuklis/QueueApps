-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
create PROCEDURE [dbo].[rajal_perawatPoli_entryTindakan_deleteResepPasien] 
	-- Add the parameters for the stored procedure here
	@idResep int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.farmasiResep Where idResep = @idResep And idStatusResep <> 1)
		Begin
			Select 'Gagal!: Resep Sedang '+ b.statusResep As respon, 0 As responCode
			  From dbo.farmasiResep a
				   Inner Join dbo.farmasiMasterStatusResep b On a.idStatusResep = b.idStatusResep
			 Where a.idResep = @idResep;
		End
	Else
		Begin Try
			Begin Tran tranzfarmaResepDel87439;
			/*UPDATE Stok Farmasi*/
			UPDATE a
			   SET a.stok += IsNull(b.jumlah, 0)
			  FROM dbo.farmasiMasterObatDetail a
				   Inner Join dbo.farmasiPenjualanDetail b On a.idObatDetail = b.idObatDetail
						Inner Join dbo.farmasiPenjualanHeader ba On b.idPenjualanHeader = ba.idPenjualanHeader
			 WHERE ba.idResep = @idResep;

			/*DELETE Penjualan Detail*/
			DELETE a
			  FROM dbo.farmasiMasterObatDetail a
				   Inner Join dbo.farmasiPenjualanDetail b On a.idObatDetail = b.idObatDetail
						Inner Join dbo.farmasiPenjualanHeader ba On b.idPenjualanHeader = ba.idPenjualanHeader
			 WHERE ba.idResep = @idResep;

			/*DELETE Resep*/
			DELETE dbo.farmasiResep
			 WHERE idResep = @idResep;

			Commit Tran tranzfarmaResepDel87439;
			Select 'Resep Berhasil Dihapus' As respon, 1 As responCode;
		End Try
		Begin Catch
			Rollback Tran tranzfarmaResepDel87439;
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch
END