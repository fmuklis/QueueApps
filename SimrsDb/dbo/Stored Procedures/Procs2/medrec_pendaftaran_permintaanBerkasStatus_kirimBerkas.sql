-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_permintaanBerkasStatus_kirimBerkas]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasien WHERE idPendaftaranPasien = @idPendaftaranPasien AND ISNULL(flagBerkasTelahDikirim, 0) = 0)
		BEGIN
			UPDATE [dbo].[transaksiPendaftaranPasien]
			   SET [flagBerkasTelahDikirim] = 1
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			SELECT 'Data Permintaan Berkas Status Dikirim' AS respon, 1 AS responCode;
		END
	ELSE
		BEGIN
			SELECT 'Data Permintaan Berkas Status Telah Dikirim' AS respon, 0 AS responCode;
		END
END