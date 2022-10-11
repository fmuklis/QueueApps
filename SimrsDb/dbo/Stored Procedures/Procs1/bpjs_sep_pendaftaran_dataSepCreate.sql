-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bpjs_sep_pendaftaran_dataSepCreate]
	-- Add the parameters for the stored procedure here
	@idSep bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SELECT c.kodePasien AS noRM, c.noBPJS, c.noHpPasien1 AS noTelp, tanggalSep, CAST(idJenisPerawatan AS varchar(50)) AS idJenisPerawatan
		  ,kodeKelasBPJS, kodeFaskes, tanggalRujukan, nomorRujukan, kodePpkRujukan, catatan, b.ICD, kodePoli, a.idJenisLaka
		  ,CAST(eksekutif AS varchar(50)) AS eksekutif, CAST(cob AS varchar(50)) AS cob, CAST(katarak AS varchar(50)) AS katarak
		  ,CAST(lakaLantas AS varchar(50)) AS lakaLantas, d.penjamin, tanggalKejadian ,a.keterangan, CAST(suplesi AS varchar(50)) AS suplesi
		  ,sepSuplesi, ea.kodePropinsi, ea.kodeKabupaten, a.kodeKecamatan, nomorSurat, kodeDpjp, dpjpLayan
	  FROM dbo.bpjsSep a
		   LEFT JOIN dbo.masterICD b ON a.idMasterICD = b.idMasterICD
		   LEFT JOIN dbo.masterPasien c ON a.idPasien = c.idPasien
		   OUTER APPLY (SELECT STUFF((SELECT ','+ CAST(xa.kodePenjamin AS varchar(50))
										FROM dbo.bpjsSepPenjaminLakalantas xa
									   WHERE xa.idSep = @idSep
				  FOR XML PATH ('')), 1, 1, '') AS penjamin) d
		   LEFT JOIN dbo.bpjsMasterKecamatan e ON a.kodeKecamatan = e.kodeKecamatan
				LEFT JOIN dbo.bpjsMasterkabupaten ea ON e.kodeKabupaten = ea.kodeKabupaten
	 WHERE a.idSep = @idSep;
END