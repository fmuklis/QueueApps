-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[rajal_perawat_tppri_listOperatorByIdJenisCatagori]
	-- Add the parameters for the stored procedure here
	@idMasterKatagoriTarip int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @Query nvarchar(max)
		   ,@Where nvarchar(max) = CASE
										WHEN @idMasterKatagoriTarip In(1,3)/*Dokter Anestesi*/
											 THEN  'WHERE b.idMasterKatagoriTarip In(1,3)'
										ELSE 'WHERE b.idMasterKatagoriTarip = '+ Convert(nvarchar(50), @idMasterKatagoriTarip) +''
									END
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @Query = '
		SELECT a.idOperator, b.idMasterKatagoriTarip, a.NamaOperator
	      FROM dbo.masterOperator a
			   Inner Join dbo.masterOperatorJenis b on a.idJenisOperator = b.idJenisOperator '+ @Where +'';

	EXEC sp_executesql @Query;
END