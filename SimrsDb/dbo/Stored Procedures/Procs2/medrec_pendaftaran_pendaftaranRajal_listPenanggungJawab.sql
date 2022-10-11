-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_listPenanggungJawab]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from masterPenanggungJawabPasien a
	inner join masterJenisKelamin c on a.idJenisKelaminPenanggungJawabPasien = c.idJenisKelamin
	inner join masterPekerjaan d on a.idPekerjaanPenanggungJawabPasien = d.idPekerjaan
	order by a.[namaPenanggungJawabPasien] asc;

END