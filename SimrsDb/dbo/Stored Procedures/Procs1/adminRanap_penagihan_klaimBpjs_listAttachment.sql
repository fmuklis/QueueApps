-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[adminRanap_penagihan_klaimBpjs_listAttachment]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien BIGINT

AS
BEGIN 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT attachment
	FROM dbo.transaksiPendaftaranPasienAttachment
	WHERE idPendaftaranPasien = @idPendaftaranPasien AND idStatusPendaftaranAttachment = 1 /*Proses Upload*/ 
END