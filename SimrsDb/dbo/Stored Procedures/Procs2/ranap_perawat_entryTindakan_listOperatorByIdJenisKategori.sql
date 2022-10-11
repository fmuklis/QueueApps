-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
create PROCEDURE [dbo].[ranap_perawat_entryTindakan_listOperatorByIdJenisKategori]
	-- Add the parameters for the stored procedure here
	@idMasterKatagoriTarip int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @Query nvarchar(max)
		   ,@Where nvarchar(max) = Case
										When @idMasterKatagoriTarip In(1,3)/*Dokter Anestesi*/
											 Then  'WHERE b.idMasterKatagoriTarip In(1,3)'
										Else 'WHERE b.idMasterKatagoriTarip = '+ Convert(nvarchar(50), @idMasterKatagoriTarip) +''
									End
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @Query = 'SELECT a.idOperator, b.idMasterKatagoriTarip, a.NamaOperator
				    FROM dbo.masterOperator a
					     Inner Join dbo.masterOperatorJenis b on a.idJenisOperator = b.idJenisOperator '+ @Where +'';
	EXEC sp_executesql @Query;
END