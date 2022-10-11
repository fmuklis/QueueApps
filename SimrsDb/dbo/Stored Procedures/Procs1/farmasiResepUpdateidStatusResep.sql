-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Stat-X
-- Create date: <Create Date,,>
-- Description:	Untuk Menerima / Update Status Order Resep
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiResepUpdateidStatusResep] 
	-- Add the parameters for the stored procedure here
	@idResep int
	,@idStatusResep int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists (Select 1 From [dbo].[farmasiResep] Where idResep = @idResep)
		Begin
			UPDATE [dbo].[farmasiResep]
			   SET [idStatusResep] = @idStatusResep
				  ,noResep = dbo.noResep('R')
			 WHERE idResep = @idResep;
			Select 'Data Berhasil Diupdate' as respon, 1 as responCode;
		End
	Else
		Begin
			Select 'Data Tidak Ditemukan' as respon, 0 as responCode;
		End
END