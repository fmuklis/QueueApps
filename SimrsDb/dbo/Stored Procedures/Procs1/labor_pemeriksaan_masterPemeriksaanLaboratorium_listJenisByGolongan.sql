-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_masterPemeriksaanLaboratorium_listJenisByGolongan]
	-- Add the parameters for the stored procedure here
	@idGolonganPemeriksaanLaboratorium tinyint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT idJenisPemeriksaanLaboratorium, jenisPemeriksaan, nomorUrut, idGolonganPemeriksaanLaboratorium = @idGolonganPemeriksaanLaboratorium
	  FROM dbo.masterLaboratoriumPemeriksaanJenis
	 WHERE idGolonganPemeriksaanLaboratorium = @idGolonganPemeriksaanLaboratorium
  ORDER BY nomorUrut
END