-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_listDokterPraktik]
	-- Add the parameters for the stored procedure here
	@idRuangan int
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idHari int = DatePart(dw, GETDATE());

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*SELECT a.idOperator,a.NamaOperator, b.jamMulai, b.JamSelesai
	  FROM dbo.masterOperator a 
		   Inner Join dbo.masterJadwalDokter b On a.idOperator = b.idOperator
	 WHERE b.idRuangan = @idRuangan And b.idHari = @idHari And b.JamSelesai > = convert(time, GetDate());*/
	SELECT a.idOperator,a.NamaOperator, b.jamMulai, b.JamSelesai
	  FROM dbo.masterOperator a 
		   Left Join dbo.masterJadwalDokter b On a.idOperator = b.idOperator
	 WHERE a.idJenisOperator Not In(6,7,8,23)
END