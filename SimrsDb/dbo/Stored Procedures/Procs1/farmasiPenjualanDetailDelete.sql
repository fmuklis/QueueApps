-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Untuk Menghapus Obat Yang Telah Dientry
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiPenjualanDetailDelete]
	-- Add the parameters for the stored procedure here
	@idPenjualanDetail int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idRacikan int
		   ,@idResepDetail int
		   ,@idResep int

	 Select @idRacikan = b.idRacikan, @idResepDetail = a.idResepDetail, @idResep = b.idResep
	   From dbo.farmasiPenjualanDetail a
			Inner Join dbo.farmasiResepDetail b On a.idResepDetail = b.idResepDetail 
	  Where a.idPenjualanDetail = @idPenjualanDetail;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If @idRacikan <> 0
		Begin Try
			Begin Tran tranzFarmaRacikanDetailDel5326;
			/*UPDATE Stok Farmasi*/
			UPDATE a
			   SET a.stok += IsNull(b.jumlah, 0)
			  FROM dbo.farmasiMasterObatDetail a
				   Inner Join dbo.farmasiPenjualanDetail b On a.idObatDetail = b.idObatDetail
						Inner Join dbo.farmasiResepDetail ba On b.idResepDetail = ba.idResepDetail
			 WHERE ba.idRacikan = @idRacikan And ba.idResep = @idResep;

			/*UPDATE Koreksi Farmasi Log Penjualan*/
			If Exists(Select 1 From dbo.farmasiJurnalStok Where idPenjualanDetail = @idPenjualanDetail)
				Begin
					UPDATE a
					   SET a.stokAwal += b.jumlah
					  FROM dbo.farmasiJurnalStok a
						   Inner Join dbo.farmasiPenjualanDetail b On a.idObatDetail = b.idObatDetail 
								Inner Join dbo.farmasiResepDetail ba On b.idResepDetail = ba.idResepDetail And ba.idResep = @idResep And ba.idRacikan = @idRacikan
					 WHERE a.idPenjualanDetail > b.idPenjualanDetail;					
				End

			/*DELETE Data Log Farmasi*/
			DELETE a
			  FROM dbo.farmasiJurnalStok a
				   Inner Join dbo.farmasiPenjualanDetail b On a.idPenjualanDetail = b.idPenjualanDetail 
						Inner Join dbo.farmasiResepDetail ba On b.idResepDetail = ba.idResepDetail
			 WHERE ba.idResep = @idResep And ba.idRacikan = @idRacikan;

			/*DELETE Penjualan Detail*/
			DELETE a
			  FROM dbo.farmasiPenjualanDetail a
				   Inner Join dbo.farmasiResepDetail b On a.idResepDetail = b.idResepDetail
			 WHERE b.idRacikan = @idRacikan And b.idResep = @idResep;

			/*DELETE Resep Detail*/
			DELETE dbo.farmasiResepDetail
			 WHERE idRacikan = @idRacikan And idResep = 	@idResep;
			
			/*Commit Tranz*/
			Commit Tran tranzFarmaRacikanDetailDel5326;

			/*Respon*/
			Select 'Resep Racikan Berhasil Dihapus' As respon, 1 As responCode;
		End Try
		Begin Catch
			/*Rollback Tranz*/
			Rollback Tran tranzFarmaRacikanDetailDel5326;
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch
	Else
		Begin Try
			Begin Tran tranzFarmaPenjualanDetailDel5326;
			/*UPDATE Stok Farmasi*/
			UPDATE a
			   SET a.stok += IsNull(b.jumlah, 0)
			  FROM dbo.farmasiMasterObatDetail a
				   Inner Join dbo.farmasiPenjualanDetail b On a.idObatDetail = b.idObatDetail
			 WHERE b.idPenjualanDetail = @idPenjualanDetail;

			/*UPDATE Koreksi Farmasi Log Penjualan*/
			UPDATE a
			   SET a.stokAwal += b.jumlah
			  FROM dbo.farmasiJurnalStok a
				   Inner Join dbo.farmasiPenjualanDetail b On a.idObatDetail = b.idObatDetail And b.idPenjualanDetail = @idPenjualanDetail
			 WHERE a.idPenjualanDetail > b.idPenjualanDetail;					

			/*DELETE Data Log Farmasi*/
			DELETE a
			  FROM dbo.farmasiJurnalStok a
			 WHERE a.idPenjualanDetail = @idPenjualanDetail;

			/*DELETE Penjualan Detail*/
			DELETE dbo.farmasiPenjualanDetail
			 WHERE idPenjualanDetail = @idPenjualanDetail;

			/*DELETE Resep Detail*/
			If Not Exists(Select 1 From dbo.farmasiPenjualanDetail a
								 Inner Join dbo.farmasiResepDetail b On a.idResepDetail = b.idResepDetail
						   Where a.idPenjualanDetail = @idPenjualanDetail)
				Begin
					DELETE dbo.farmasiResepDetail
					 WHERE idResepDetail = @idResepDetail;
				End
			
			/*Commit Tranz*/
			Commit Tran tranzFarmaPenjualanDetailDel5326;

			/*Respon*/
			Select 'Resep Berhasil Dihapus' As respon, 1 As responCode;
		End Try
		Begin Catch
			/*Rollback Tranz*/
			Rollback Tran tranzFarmaPenjualanDetailDel5326;
			Select 'Error!: '+ ERROR_MESSAGE() As respon, 0 As responCode;
		End Catch
END