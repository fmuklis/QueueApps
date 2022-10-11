-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
create PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_listKelasKamarForAdmisi] 
	-- Add the parameters for the stored procedure here
	@idKelas int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [namaKelas]
		  ,[idKelas]
	  FROM [dbo].[masterKelas] a
	 WHERE idKelas = @idKelas Or a.pelayanan = 1
END