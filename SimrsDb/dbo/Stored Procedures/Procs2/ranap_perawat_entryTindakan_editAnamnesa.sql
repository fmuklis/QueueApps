-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ranap_perawat_entryTindakan_editAnamnesa]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint,
	@idJenisPelayananRawatInap tinyint,
	@anamnesa varchar(MAX)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		-- Insert statements for procedure here
	UPDATE [dbo].[transaksiPendaftaranPasien]
	   SET [anamnesa] = @anamnesa
	 WHERE idPendaftaranPasien = @idPendaftaranPasien;

	UPDATE [dbo].[transaksiPendaftaranPasienDetail]
	   SET [idJenisPelayananRawatInap] = @idJenisPelayananRawatInap
	 WHERE idPendaftaranPasien = @idPendaftaranPasien AND aktif = 1/*Current Bed*/;

	SELECT 'Pelayanan & Anamnesa Pasien Berhasil Diupdate' AS respon, 1 AS responCode;
END