-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bpjs_sep_pendaftaran_deleteRujukan]
	-- Add the parameters for the stored procedure here
	@idRujukan bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE [dbo].[bpjsRujukan]
	 WHERE idRujukan = @idRujukan;
END