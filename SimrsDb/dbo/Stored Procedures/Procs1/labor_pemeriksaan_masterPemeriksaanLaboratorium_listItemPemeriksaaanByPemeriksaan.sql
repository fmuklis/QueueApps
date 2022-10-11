-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_masterPemeriksaanLaboratorium_listItemPemeriksaaanByPemeriksaan]
	-- Add the parameters for the stored procedure here
	@idPemeriksaanLaboratorium int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idItemPemeriksaanLaboratorium, itemPemeriksaan, nomorUrut,aktif
	  FROM dbo.masterLaboratoriumPemeriksaanItem a
	 WHERE a.idPemeriksaanLaboratorium = @idPemeriksaanLaboratorium
  ORDER BY nomorUrut
END