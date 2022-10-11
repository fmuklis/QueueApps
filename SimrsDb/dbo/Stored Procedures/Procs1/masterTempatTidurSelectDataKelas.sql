-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterTempatTidurSelectDataKelas]
	-- Add the parameters for the stored procedure here
	@idRuangan int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Distinct a.idKelas, b.namaKelas
	  FROM dbo.masterRuanganRawatInap a
		   Inner Join dbo.masterKelas b On a.idKelas = b.idKelas
	 WHERE a.idRuangan = @idRuangan
  ORDER BY a.idKelas
END