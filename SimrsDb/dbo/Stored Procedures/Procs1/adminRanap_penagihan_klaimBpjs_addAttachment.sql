-- =============================================
-- Author:		eko
-- Create date: 8-04-2021
-- Description:	-
-- =============================================
CREATE PROCEDURE [dbo].[adminRanap_penagihan_klaimBpjs_addAttachment]
	-- Add the parameters for the stored procedure here
	@attachment VARCHAR(100),
	@idPendaftaranPasien BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[transaksiPendaftaranPasienAttachment]
			   ([attachment]
			   ,[idPendaftaranPasien]
			   ,[idStatusPendaftaranAttachment])
		 VALUES
			   (@attachment
			   ,@idPendaftaranPasien
			   ,1 /*Proses Upload*/)

	 SELECT 'Berkas Berhasil Diupload' AS respon, 1 AS responCode;

END