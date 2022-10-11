-- =============================================
-- Author     :	Start -X
-- Create date: <Create Date,,>
-- Description:	Menampilkan Daftar Pasien Yang Order Farmasi
-- =============================================
CREATE PROCEDURE farmasi_penjualan_dashboard_requestDiterima
	-- Add the parameters for the stored procedure here
	@idResep bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*UPDATE Status Resep*/
	UPDATE dbo.farmasiResep
	   SET idStatusResep = 2/*Dalam Proses*/
	 WHERE idResep = @idResep;

	/*Respon*/
	Select 'Permintaan Resep Diterima' As respon, 1 As responCode;
END