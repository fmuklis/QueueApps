-- =============================================
-- Author     :	Start -X
-- Create date: <Create Date,,>
-- Description:	Menampilkan Daftar Pasien Yang Order Farmasi
-- =============================================
CREATE PROCEDURE farmasi_penjualan_dashboard_requestBatal
	-- Add the parameters for the stored procedure here
	@idResep bigint,
	@keterangan varchar(500)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*UPDATE Status Resep*/
	UPDATE dbo.farmasiResep
	   SET idStatusResep = 4/*Batal*/
		  ,keterangan = @keterangan
	 WHERE idResep = @idResep;

	/*Respon*/
	Select 'Permintaan Resep Berhasil Dibatalkan' As respon, 1 As responCode;
END