-- =============================================
-- Author     :	Start -X
-- Create date: <Create Date,,>
-- Description:	Menampilkan Daftar Pasien Yang Order Farmasi
-- =============================================
CREATE PROCEDURE farmasi_penjualan_dashboard_requestBatalDiterima
	-- Add the parameters for the stored procedure here
	@idResep bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select Top 1 1 
				From dbo.farmasiPenjualanHeader a
					 Inner Join dbo.farmasiPenjualanDetail b On a.idPenjualanHeader = b.idPenjualanHeader
			   Where a.idResep = @idResep)
		Begin
			/*Respon*/
			Select 'Tidak Dapat Dibatalkan, Hapus Data Penjualan Obat Terlebih Dahulu' As respon, 0 As responCode;			
		End
	Else
		Begin
			/*DELETE Data Penjualan Header*/
			DELETE dbo.farmasiPenjualanHeader
			 WHERE idResep = @idResep;

			/*UPDATE Status Resep*/
			UPDATE dbo.farmasiResep
			   SET idStatusResep = 1/*Order Farmasi*/
			 WHERE idResep = @idResep;

			/*Respon*/
			Select 'Permintaan Resep Batal Diterima' As respon, 1 As responCode;
		End
END