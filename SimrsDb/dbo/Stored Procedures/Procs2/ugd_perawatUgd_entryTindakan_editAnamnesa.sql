-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[ugd_perawatUgd_entryTindakan_editAnamnesa]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint,
	@anamnesa varchar(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		-- Insert statements for procedure here
	UPDATE [dbo].[transaksiPendaftaranPasien]
	   SET [anamnesa] = @anamnesa
	 WHERE idPendaftaranPasien = @idPendaftaranPasien

	SELECT 'Anamnesa Berhasil Dimasukan' AS respon, 1 AS responCode;
END