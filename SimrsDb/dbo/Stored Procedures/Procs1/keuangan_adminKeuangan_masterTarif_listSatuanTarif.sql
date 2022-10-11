CREATE PROCEDURE [dbo].[keuangan_adminKeuangan_masterTarif_listSatuanTarif]

AS
BEGIN
	SET NOCOUNT ON;
	Select * 
	From [dbo].[masterSatuanTarif] 
	Order By [namaSatuanTarif] Asc
END