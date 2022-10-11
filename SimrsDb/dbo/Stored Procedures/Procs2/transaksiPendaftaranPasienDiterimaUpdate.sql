-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienDiterimaUpdate]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[transaksiPendaftaranPasien]
	   SET [idStatusPendaftaran] = 2/*Perawatan*/
	 WHERE [idStatusPendaftaran] = @idPendaftaranPasien;
	Select 'Data berhasil diupdate' as respon, 1 as responCode;	
END