-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_masterPemeriksaanLaboratorium_listItemPemeriksaaan]
	-- Add the parameters for the stored procedure here
	@idPemeriksaanLaboratorium int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idItemPemeriksaanLaboratorium, b.idDetailItemPemeriksaanLaboratorium, a.itemPemeriksaan, b.detailItemPemeriksaan, b.satuan, b.nilaiRujukan
	  FROM dbo.masterLaboratoriumPemeriksaanItem a
		   LEFT JOIN dbo.masterLaboratoriumPemeriksaanItemDetail b ON a.idItemPemeriksaanLaboratorium = b.idItemPemeriksaanLaboratorium
	 WHERE a.idPemeriksaanLaboratorium = @idPemeriksaanLaboratorium
  ORDER BY a.nomorUrut, b.nomorUrut
END