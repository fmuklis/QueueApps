-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bpjs_sep_pendaftaran_addPengajuanSep]
	-- Add the parameters for the stored procedure here
	@noKartu varchar(50),
	@tglSep date,
	@jnsPelayanan tinyint,
	@jnsPengajuan tinyint,
	@keterangan varchar(500)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF NOT EXISTS(SELECT 1 FROM dbo.bpjsSepPengajuan WHERE noKartu = @noKartu AND tanggalSep = @tglSep AND jenisPelayanan = @jnsPelayanan)
		BEGIN
			INSERT INTO [dbo].[bpjsSepPengajuan]
					   ([noKartu]
					   ,[tanggalSep]
					   ,[jenisPelayanan]
					   ,[jenisPengajuan]
					   ,[keterangan])
				 VALUES
					   (@noKartu
					   ,@tglSep
					   ,@jnsPelayanan
					   ,@jnsPengajuan
					   ,@keterangan)
		END
END