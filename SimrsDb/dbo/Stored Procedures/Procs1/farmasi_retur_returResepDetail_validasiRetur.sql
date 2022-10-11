-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_retur_returResepDetail_validasiRetur]
	-- Add the parameters for the stored procedure here
	@idResep bigint,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.farmasiPenjualanHeader a
			   Where a.idResep = @idResep And a.idBilling Is Not Null)
		Begin
			Select 'Tidak Dapat Diretur, Resep Telah Dibayar Oleh Pasien' As respon, 0 As responCode;
		End
	Else If Not Exists(Select Top 1 1 From dbo.farmasiPenjualanHeader a
							  Inner Join dbo.farmasiPenjualanDetail b On a.idPenjualanHeader = b.idPenjualanHeader
							  Inner Join dbo.farmasiReturDetail ba On b.idPenjualanDetail = ba.idPenjualanDetail
						Where a.idResep = @idResep And ba.valid = 0/*Belum Divalidasi*/)
		Begin
			Select 'Tidak Ada Proses Retur Yang Dapat Divalidasi' As respon, 0 As responCode;
		End
	Else
		Begin Try
			/*Transaction Begin*/
			Begin Tran;

			/*INSERT Log Farmasi*/
			INSERT INTO [dbo].[farmasiJurnalStok]
					   ([idObatDetail]
					   ,[idReturDetail]
					   ,[stokAwal]
					   ,[jumlahMasuk]
					   ,[stokAkhir]
					   ,[idUserEntry])
				 SELECT b.idObatDetail
					   ,a.idReturDetail
					   ,bb.stok
					   ,a.jumlahRetur
					   ,bb.stok + a.jumlahRetur
					   ,@idUserEntry
			  FROM dbo.farmasiReturDetail a
				   Inner Join dbo.farmasiPenjualanDetail b On a.idPenjualanDetail = b.idPenjualanDetail
						Inner Join dbo.farmasiPenjualanHeader ba On b.idPenjualanHeader = b.idPenjualanHeader
						Inner Join dbo.farmasiMasterObatDetail bb On b.idObatDetail = bb.idObatDetail
			 WHERE ba.idResep = @idResep And a.valid = 0/*Belum Divalidasi*/;

			/*UPDATE Tambah Stok*/
			UPDATE a
			   SET a.stok += IsNull(bb.jumlahRetur, 0)
			  FROM dbo.farmasiMasterObatDetail a
				   Inner Join dbo.farmasiPenjualanDetail b On a.idObatDetail = b.idObatDetail
						Inner Join dbo.farmasiPenjualanHeader ba On b.idPenjualanHeader = ba.idPenjualanHeader
						Inner Join dbo.farmasiReturDetail bb On b.idPenjualanDetail = bb.idPenjualanDetail
			 WHERE ba.idResep = @idResep And bb.valid = 0/*Belum Divalidasi*/;

			/*UPDATE Mengurangi Jumlah Obat Yg Terjual*/
			UPDATE a
			   SET a.jumlah -= IsNull(d.jumlahRetur, 0)
			  FROM dbo.farmasiPenjualanDetail a
				   Inner Join dbo.farmasiMasterObatDetail b On a.idObatDetail = b.idObatDetail
				   Inner Join dbo.farmasiPenjualanHeader c On a.idPenjualanHeader = c.idPenjualanHeader
				   Inner Join dbo.farmasiReturDetail d On a.idPenjualanDetail = d.idPenjualanDetail
			 WHERE c.idResep = @idResep And d.valid = 0/*Belum Divalidasi*/;
			

			/*UPDATE Ubah Status Retur Valid*/
			UPDATE a
			   SET a.valid = 1
			  FROM dbo.farmasiReturDetail a
				   Inner Join dbo.farmasiPenjualanDetail b On a.idPenjualanDetail = b.idPenjualanDetail
						Inner Join dbo.farmasiPenjualanHeader ba On b.idPenjualanHeader = b.idPenjualanHeader
			 WHERE ba.idResep = @idResep And a.valid = 0/*Belum Divalidasi*/

			/*Transaction Commit*/
			Commit Tran;
			Select 'Data Retur Berhasil Divalidasi' As respon, 1 As responCode;
 		End Try
		Begin Catch
			/*Rollback Commit*/
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		End Catch
END