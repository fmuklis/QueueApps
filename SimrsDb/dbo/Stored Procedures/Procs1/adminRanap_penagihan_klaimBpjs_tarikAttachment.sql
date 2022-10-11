-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
create PROCEDURE [dbo].[adminRanap_penagihan_klaimBpjs_tarikAttachment]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien BIGINT

AS
BEGIN 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[transaksiPendaftaranPasienAttachment]
	   SET [idStatusPendaftaranAttachment] = 2 /*Ditarik / Download*/
	 WHERE idPendaftaranPasien = @idPendaftaranPasien AND idStatusPendaftaranAttachment = 1 /*Proses Upload*/

	SELECT 'Berkas Berhasil Ditarik / Download' AS respon, 1 AS responCode;
END