-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[rajal_perawatPoli_entryTindakan_selectByIdRuanganOperator]
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--Declare @idJenisOperator int = (Select idJenisOperator From dbo.masterRuangan Where idRuangan = @idRuangan)

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [idJenisOperator]
		  ,[namaJenisOperator]
		  ,[idMasterKatagoriTarip]
	  FROM [dbo].[masterOperatorJenis]
	-- WHERE idJenisOperator In(@idJenisOperator,1)
  ORDER BY namaJenisOperator
END