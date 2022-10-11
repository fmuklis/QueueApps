-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bpjs_sep_pendaftaran_dataPasien]
	-- Add the parameters for the stored procedure here
	@noKartuBPJS VARCHAR(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT kodePasien, nomorRujukan
	  FROM dbo.masterPasien a 
		LEFT JOIN dbo.bpjsSep b ON a.idPasien = b.idPasien
	 WHERE noBPJS = @noKartuBPJS
END