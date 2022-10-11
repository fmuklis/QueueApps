-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterTempatTidurSelectDataRuangan]
	-- Add the parameters for the stored procedure here
	@idRuangan int,
	@idKelas int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Distinct idRuanganRawatInap, namaRuanganRawatInap
	  FROM dbo.masterRuanganRawatInap
	 WHERE idRuangan = @idRuangan And idKelas = @idKelas 
  ORDER BY idRuanganRawatInap
END