-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[rajal_perawatPoli_entryTindakan_selectByIDPendaftaranPasien]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idDiagNosa, a.tglDiagnosa, b.NamaOperator, a.anamnesa, d.idPelayananIGD, da.namaPelayananIGD
		  ,c.diagnosa, e.ICD, e.diagnosa As namaPenyakit
		  ,Case
				When a.primer = 1
					 Then 'Primer'
				Else 'Skunder'
			End As jenis
	  FROM dbo.transaksiDiagnosaPasien a
		   Left Join dbo.masterOperator b On a.idDokter = b.idOperator
		   Inner Join dbo.masterDiagnosa c On a.idMasterDiagnosa = c.idMasterDiagnosa
		   Inner Join dbo.transaksiPendaftaranPasien d On a.idPendaftaranPasien = d.idPendaftaranPasien
				Left Join dbo.masterPelayananIGD da On d.idPelayananIGD = da.idPelayananIGD 
		   Left Join dbo.masterICD e On a.idMasterICD = e.idMasterICD
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
  ORDER BY a.primer DESC;
END