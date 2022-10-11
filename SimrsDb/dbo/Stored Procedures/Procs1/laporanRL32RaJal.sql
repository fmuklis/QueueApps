-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laporanRL32RaJal]
	-- Add the parameters for the stored procedure here
	@tahun int
	,@bulan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.namaJenisPenjaminPembayaranPasien
		  ,Count(b.namaJenisPenjaminPembayaranPasien) As jumlah
	  FROM dbo.transaksiPendaftaranPasien a
		   Left Join dbo.masterJenisPenjaminPembayaranPasien b On a.idJenisPenjaminPembayaranPasien = b.idJenisPenjaminPembayaranPasien
	 WHERE a.idJenisPendaftaran = 1/*IGD*/ And a.idJenisPerawatan = 2/*RaJal*/ And Year(a.tglDaftarPasien) = @tahun And Month(a.tglDaftarPasien) = @bulan
  GROUP BY b.namaJenisPenjaminPembayaranPasien, b.idJenisPenjaminInduk
  ORDER BY b.idJenisPenjaminInduk, b.namaJenisPenjaminPembayaranPasien
END