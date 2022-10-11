-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterPenanggungJawabSelectByNama]
	-- Add the parameters for the stored procedure here
	@namaPenanggungJawabPasien nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from masterPenanggungJawabPasien a
	inner join masterJenisKelamin c on a.idJenisKelaminPenanggungJawabPasien = c.idJenisKelamin
	inner join masterPekerjaan d on a.idPekerjaanPenanggungJawabPasien = d.idPekerjaan
	where a.[namaPenanggungJawabPasien] like '%' + @namaPenanggungJawabPasien + '%' order by a.[namaPenanggungJawabPasien] asc;

END