-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[farmasi_pemakaianInternal_entryPemakaianInternalDetail_dataPemakaianInternal]
	-- Add the parameters for the stored procedure here
	@idPemakaianInternal bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.tanggalPermintaan, '-' AS kodePemakaianInternal, b.namaBagian AS unit, a.pemohon, c.statusPemakaianInternal
	  FROM dbo.farmasiPemakaianInternal a
		   LEFT JOIN dbo.farmasiPemakaianInternalBagian b ON a.idBagian = b.idBagian
		   LEFT JOIN dbo.farmasiMasterStatusPemakaianInternal c ON a.idStatusPemakaianInternal = c.idStatusPemakaianInternal
	 WHERE a.idPemakaianInternal = @idPemakaianInternal
END