-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Menampilkan Operator Berdasarkan Jenisnya
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[rajal_perawat_tppri_listOperatorByidJenisOperator]
	-- Add the parameters for the stored procedure here
	 @dokter bit
	,@perawat bit
	,@bidan bit
	,@idRuangan int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @where nvarchar(max)
		   ,@query nvarchar(max)
		Set @where = Case
						When @dokter = 1 
							Then 'Where b.idMasterKatagoriTarip In(1,3)'
						When @perawat = 1
							Then 'Where b.idMasterKatagoriTarip = 5'
						When @bidan = 1
							Then 'Where b.idMasterKatagoriTarip = 5'
						Else ''
					 End
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Set @query = 'SELECT idOperator, NamaOperator
				  FROM dbo.masterOperator a
					   Inner Join dbo.masterOperatorJenis b On a.idJenisOperator = b.idJenisOperator '+ @where +'';
	Exec sp_executesql @query;
END