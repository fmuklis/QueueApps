-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author	  :	Start-X
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE spPasien_GetRiwayatDiagnosa
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*Make variable*/
	DECLARE @idPasien int;
	
	/*SET variable value*/
	SELECT @idPasien = idPasien
	  FROM dbo.transaksiPendaftaranPasien
	 WHERE idPendaftaranPasien = @idPendaftaranPasien;

	SELECT DISTINCT a.idPendaftaranPasien, tglDiagnosa, e.diagnosa
		  ,a.idDokter, c.NamaOperator, a.idRuangan, d.Alias
		  ,Case
				When a.idMasterDiagnosa Is Null
					 Then a.diagnosaAwal
				Else dbo.diagnosaPasien(a.idPendaftaranPasien)
			End As diagnosaAwal
	  FROM dbo.transaksiDiagnosaPasien a
		   INNER JOIN dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
		   LEFT JOIN dbo.masterOperator c On a.idDokter = c.idOperator
		   LEFT JOIN dbo.masterRuangan d On a.idRuangan = d.idRuangan
		   LEFT JOIN dbo.masterDiagnosa e On a.idMasterDiagnosa = e.idMasterDiagnosa
	 WHERE b.idPasien = @idPasien And b.idPendaftaranPasien <> @idPendaftaranPasien
  ORDER BY a.idPendaftaranPasien

END