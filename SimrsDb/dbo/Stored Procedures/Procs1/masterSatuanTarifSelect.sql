CREATE PROCEDURE [dbo].[masterSatuanTarifSelect]

AS
BEGIN
	SET NOCOUNT ON;
	Select * 
	From [dbo].[masterSatuanTarif] 
	Order By [namaSatuanTarif] Asc
END