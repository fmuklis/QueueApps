-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bpjs_sep_pendaftaran_validasiRujukan]
	-- Add the parameters for the stored procedure here
	@idRujukan bigint,
	@nomorRujukan varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[bpjsRujukan]
	   SET [nomorRujukan] = @nomorRujukan
	 WHERE idRujukan = @idRujukan;
END