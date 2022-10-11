-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bpjs_sep_pendaftaran_deleteSep]
	-- Add the parameters for the stored procedure here
	@noSep varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE dbo.transaksiPendaftaranPasien
	   SET noSEPRawatJalan = NULL
	 WHERE noSEPRawatJalan = @noSep;

	UPDATE dbo.transaksiPendaftaranPasien
	   SET noSEPRawatInap = NULL
	 WHERE noSEPRawatInap = @noSep;

	DELETE dbo.bpjsSep
	 WHERE nomorSep = @noSep;
END