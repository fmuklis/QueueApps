
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_listKelasRuangan] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [namaKelas] as namaKelasRuangan
		  ,[idKelas] as idKelasRuangan
	  FROM [dbo].[masterKelas]
END