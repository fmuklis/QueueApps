-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE bpjs_sep_pendaftaran_listPenjaminLakaLantas
	-- Add the parameters for the stored procedure here
	@idSep bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SELECT kodePenjamin
	  FROM dbo.bpjsSepPenjaminLakalantas
	 WHERE idSep = @idSep;
END