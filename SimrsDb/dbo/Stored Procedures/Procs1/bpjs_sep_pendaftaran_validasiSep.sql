﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bpjs_sep_pendaftaran_validasiSep]
	-- Add the parameters for the stored procedure here
	@idSep bigint,
	@nomorSep varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
 
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[bpjsSep]
	   SET [nomorSep] = @nomorSep
	 WHERE idSep = @idSep;
END