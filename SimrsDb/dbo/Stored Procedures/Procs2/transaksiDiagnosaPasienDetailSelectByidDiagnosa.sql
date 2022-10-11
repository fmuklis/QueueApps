-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiDiagnosaPasienDetailSelectByidDiagnosa] 
	-- Add the parameters for the stored procedure here
	@idDiagnosa int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [idDiagnosaDetail]
		  ,[idDiagnosa]
		  ,Case	
				When a.sekunder = 0
					 Then 'Primer'
				Else 'Sekunder'
			End As namaJenisDiagnosa
		  ,a.[idPenyakit], c.kodeICD, c.namaPenyakit, c.keterangan
		  ,[idUserEntry]
		  ,[tglEntry]
	  FROM [dbo].[transaksiDiagnosaPasienDetail] a

		   Inner Join dbo.masterPenyakit c On a.idPenyakit = c.idPenyakit
	 WHERE a.idDiagnosa = @idDiagnosa
END