-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laporanPasienOperasiSelectOkGolonganSpesialis]
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Distinct a.idGolonganSpesialis, b.golonganSpesialis
	  FROM dbo.transaksiOrderOK a
		   Inner Join dbo.masterOkGolonganSpesialis b On a.idGolonganSpesialis = b.idGolonganSpesialis
	 WHERE Convert(date, a.tglOperasi) Between @periodeAwal And @periodeAkhir
  ORDER BY b.golonganSpesialis
END