-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterJenisPenjaminPembayaranPasienSelectByidJenisPenjaminInduk]
	-- Add the parameters for the stored procedure here
	@idJenisPenjaminInduk int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @query nvarchar(max)
		   ,@where nvarchar(max) = Case
										When @idJenisPenjaminInduk <> 0
											 Then 'WHERE a.idJenisPenjaminInduk = '+Convert(nvarchar(20), @idJenisPenjaminInduk)+''
										Else ''										 									
									End
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @query = 'SELECT a.idJenisPenjaminInduk, a.idJenisPenjaminPembayaranPasien, a.namaJenisPenjaminPembayaranPasien
					FROM dbo.masterJenisPenjaminPembayaranPasien a '+ @where +'
				ORDER BY a.idJenisPenjaminInduk, a.namaJenisPenjaminPembayaranPasien';
	EXEC (@query);
END