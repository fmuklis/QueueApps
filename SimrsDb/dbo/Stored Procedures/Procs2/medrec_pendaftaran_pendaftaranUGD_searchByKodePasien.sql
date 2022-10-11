-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranUGD_searchByKodePasien]
	-- Add the parameters for the stored procedure here
	 @kodePasien nchar(6)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if exists(Select 1 from masterPasien a where a.kodePasien = @kodePasien)
		Begin
			Execute [dbo].[medrec_pendaftaran_pendaftaranRajal_searchByKodePasien] @kodePasien;
		End
	else
		Begin
			Select 'Data tidak ditemukan' as respon, 0 as responCode;
		End
END