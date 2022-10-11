-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_gudangFarmasi_penghapusBarangExpired_cetakDataPenghapusanBarang]
	-- Add the parameters for the stored procedure here
	@idPenghapusanStok bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.tanggalPenghapusan, a.kodePenghapusan, b.namaPetugasFarmasi
	  FROM dbo.farmasiPenghapusanStok a
		   LEFT JOIN dbo.farmasiMasterPetugas b ON a.idPetugas = b.idPetugasFarmasi
	 WHERE a.idPenghapusanStok = @idPenghapusanStok
END