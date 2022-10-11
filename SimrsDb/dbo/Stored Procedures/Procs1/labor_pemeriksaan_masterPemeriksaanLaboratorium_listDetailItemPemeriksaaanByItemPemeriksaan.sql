-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_masterPemeriksaanLaboratorium_listDetailItemPemeriksaaanByItemPemeriksaan]
	-- Add the parameters for the stored procedure here
	@idItemPemeriksaanLaboratorium int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idDetailItemPemeriksaanLaboratorium, detailItemPemeriksaan, nomorUrut,aktif,satuan,nilaiRujukan
	  FROM dbo.masterLaboratoriumPemeriksaanItemDetail a
	 WHERE a.idItemPemeriksaanLaboratorium = @idItemPemeriksaanLaboratorium
  ORDER BY nomorUrut
END