﻿-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterOperatorSelect]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [idOperator]
		  ,a.[idJenisOperator]
		  ,[NamaOperator]
		  ,b.[namaJenisOperator]
	  FROM [dbo].[masterOperator] a
		   Inner Join [dbo].[masterOperatorJenis] b On a.idJenisOperator = b.idJenisOperator
  ORDER BY [namaJenisOperator],[NamaOperator]
END