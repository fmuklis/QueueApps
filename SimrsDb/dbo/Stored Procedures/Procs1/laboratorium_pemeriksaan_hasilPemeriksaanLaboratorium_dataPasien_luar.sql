-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laboratorium_pemeriksaan_hasilPemeriksaanLaboratorium_dataPasien_luar]
	-- Add the parameters for the stored procedure here
	@idOrder bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.tglOrder, a.tanggalSampel, a.nomorLabor, b.tglLahir, b.namaPasien, b.umur
		  ,b.namaJenisKelamin, 'UMUM' AS penjamin, b.DPJP, a.keteranganHasilPemeriksaan AS keterangan
		  ,c.namaLengkap AS otorisator
	  FROM dbo.transaksiOrder a
		   OUTER APPLY dbo.getInfo_dataPasienLuar(a.idPasienLuar, a.tglOrder) b
		   LEFT JOIN dbo.masterUser c ON a.idUserOtorisasi = c.idUser
	 WHERE a.idOrder = @idOrder
END