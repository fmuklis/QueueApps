-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bpjs_sep_pendaftaran_dataPengajuanSep]
	-- Add the parameters for the stored procedure here
	@idPengajuan bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.noKartu, a.tanggalSep, a.jenisPelayanan, a.keterangan, a.jenisPengajuan
	  FROM dbo.bpjsSepPengajuan a
	 WHERE a.idPengajuan = @idPengajuan
END