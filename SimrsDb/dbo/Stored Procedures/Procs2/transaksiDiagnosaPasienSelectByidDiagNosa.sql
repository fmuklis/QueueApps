-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiDiagnosaPasienSelectByidDiagNosa]
	-- Add the parameters for the stored procedure here
	@idDiagNosa int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idDiagNosa, a.tglDiagnosa, b.NamaOperator, b.idOperator, d.idPelayananIGD, da.namaPelayananIGD
		  ,c.diagnosa, a.primer, c.idMasterDiagnosa, c.diagnosa
		  ,Case
				When a.primer = 1
					 Then 'Primer'
				Else 'Skunder'
			End As jenis
	  FROM dbo.transaksiDiagnosaPasien a
		   Inner Join dbo.masterOperator b On a.idDokter = b.idOperator
		   Inner Join dbo.masterDiagnosa c On a.idMasterDiagnosa = c.idMasterDiagnosa
		   Inner Join dbo.transaksiPendaftaranPasien d On a.idPendaftaranPasien = d.idPendaftaranPasien
				Left Join dbo.masterPelayananIGD da On d.idPelayananIGD = da.idPelayananIGD 
	 WHERE a.idDiagNosa = @idDiagNosa
END