-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[radiologi_pemeriksaan_entryTindakan_select_dataPasienLuar]
	-- Add the parameters for the stored procedure here
	@idOrder bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idOrder, a.tglOrder, a.kodeOrder, b.nama, ba.idJenisKelamin, ba.namaJenisKelamin
		  ,b.tglLahir, b.alamat, b.tlp, b.dokter
	  FROM dbo.transaksiOrder a
		   INNER JOIN dbo.masterPasienLuar b On a.idPasienLuar = b.idPasienLuar
				INNER JOIN dbo.masterJenisKelamin ba On b.idJenisKelamin = ba.idJenisKelamin
	 WHERE a.idOrder = @idOrder
END