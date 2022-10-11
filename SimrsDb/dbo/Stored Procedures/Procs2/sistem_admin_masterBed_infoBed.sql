-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[sistem_admin_masterBed_infoBed]
	-- Add the parameters for the stored procedure here
	@idTempatTidur int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idTempatTidur, b.idRuangan, b.idJenisPelayananRawatInap, ba.namaRuangan As namaGedung, ba.Alias, b.namaRuanganRawatInap
		  ,a.kapasitas, c.idKelas, c.namaKelas As namaKelasRuangan, a.noTempatTidur, a.flagMasihDigunakan, a.tanggalDigunakan
		  ,a.tanggalNonaktif, a.keteranganTempatTidur 
	  FROM dbo.masterRuanganTempatTidur a 
		   LEFT JOIN dbo.masterRuanganRawatInap b ON a.idRuanganRawatInap = b.idRuanganRawatInap
				LEFT JOIN dbo.masterRuangan ba ON b.idRuangan = ba.idRuangan 
		   LEFT JOIN dbo.masterKelas c ON b.idKelas = c.idKelas
	 WHERE a.idTempatTidur = @idTempatTidur
END