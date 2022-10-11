-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[ugd_perawatUgd_entryTindakan_diagnosaByIdPendaftaranPasien]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idDiagNosa, a.tglDiagnosa, b.idOperator, b.NamaOperator, a.anamnesa, d.idPelayananIGD, da.namaPelayananIGD
		  ,c.diagnosa
		  ,Case
				When a.primer = 1
					 Then 'Primer'
				Else 'Skunder'
			End As jenis
	  FROM dbo.transaksiDiagnosaPasien a
		   Left Join dbo.masterOperator b On a.idDokter = b.idOperator
		   INNER JOIN dbo.masterICD c ON a.idMasterICD = c.idMasterICD
		   Inner Join dbo.transaksiPendaftaranPasien d On a.idPendaftaranPasien = d.idPendaftaranPasien
				Left Join dbo.masterPelayananIGD da On d.idPelayananIGD = da.idPelayananIGD 
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
  ORDER BY a.primer DESC;
END