-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranUGD_deletePendaftaranPasien] 
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists (Select 1 From dbo.transaksiTindakanPasien Where idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			Select 'Gagal!: Sudah Ada Tindakan Pada Pasien Ini' As respon, 0 As responCode;
		End
	Else
		Begin
			DELETE FROM [dbo].[transaksiPendaftaranPasien]
				  WHERE idPendaftaranPasien = @idPendaftaranPasien;
			Select 'Data Berhasil Dihapus' As respon, 1 As responCode;
		End
END