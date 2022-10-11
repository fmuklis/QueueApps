-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterRuanganTempatTidurDelete]
	-- Add the parameters for the stored procedure here
	@idTempatTidur int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select Top 1 1 From dbo.transaksiPendaftaranPasienDetail Where idTempatTidur = @idTempatTidur)
		Begin
			Select 'Tidak Dapat Dihapus, Bed Telah Digunakan Pada Riwayat Pasien Rawat' As respon, 0 As responCode;
		End
	Else
		Begin
			DELETE dbo.masterRuanganTempatTidur
			 WHERE idTempatTidur = @idTempatTidur;

			Select 'Data Bed Kamar Inap Berhasil Dihapus' As respon, 1 As responCode;
		End
END