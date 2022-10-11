-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_hasilPemeriksaanLaboratoriumCetak_dataPasienLuar]
	-- Add the parameters for the stored procedure here
	@idOrder bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.nomorLabor, a.tanggalSampel, a.tanggalHasil, b.namaPasien, b.tglLahir, b.umur
		  ,b.alamatPasien, b.namaJenisKelamin, b.DPJP, c.namaLengkap AS otorisator
		  ,d.NamaOperator AS penanggungjawab, a.keteranganHasilPemeriksaan AS keterangan
	  FROM dbo.transaksiOrder a
		   OUTER APPLY dbo.getInfo_dataPasienLuar(a.idPasienLuar, a.tglOrder) b
		   LEFT JOIN dbo.masterUser c ON a.idUserOtorisasi = c.idUser
		   LEFT JOIN dbo.masterOperator d ON a.idPenanggungjawabLaboratorium = d.idOperator
	 WHERE a.idOrder = @idOrder
END