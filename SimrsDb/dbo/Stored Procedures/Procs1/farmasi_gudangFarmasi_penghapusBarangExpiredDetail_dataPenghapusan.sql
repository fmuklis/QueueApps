-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_gudangFarmasi_penghapusBarangExpiredDetail_dataPenghapusan]
	-- Add the parameters for the stored procedure here
	@idPenghapusanStok bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.kodePenghapusan, a.tanggalPenghapusan, b.namaPetugasFarmasi AS pemohon
	FROM dbo.farmasiPenghapusanStok a
		LEFT JOIN dbo.farmasiMasterPetugas b ON a.idPetugas = b.idPetugasFarmasi
	WHERE idPenghapusanStok = @idPenghapusanStok
END