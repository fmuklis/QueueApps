-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[rajal_perawatPoli_perawatanPasien_terimaPasien]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			Select 'Data Tidak Ditemukan' as respon, 0 as responCode;
		End
	Else
		Begin
			UPDATE [dbo].[transaksiPendaftaranPasien]
			   SET [idStatusPendaftaran] = 2/*Perawatan*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;
			Select 'Data Berhasil Diupdate' as respon, 1 as responCode;
		End
END