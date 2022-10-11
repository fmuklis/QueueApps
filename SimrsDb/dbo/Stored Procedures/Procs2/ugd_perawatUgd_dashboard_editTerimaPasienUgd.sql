-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
create PROCEDURE [dbo].[ugd_perawatUgd_dashboard_editTerimaPasienUgd]
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
			Select 'Data Tidak Ditemukan' As respon, 0 As responCode;
		End
	Else
		Begin
			UPDATE [dbo].[transaksiPendaftaranPasien]
			   SET [idStatusPendaftaran] = 3/*Perawatan IGD*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;
			Select 'Berhasil, Pasien Dalam Perawatan IGD' As respon, 1 As responCode;
		End
END