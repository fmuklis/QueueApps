
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bpjs_sep_pendaftaran_dataSepEdit]
	-- Add the parameters for the stored procedure here
	@nomorSep varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @idSep bigint = (SELECT idSep FROM dbo.bpjsSep WHERE nomorSep = @nomorSep);
	-- interfering with SELECT statements.
	SELECT c.kodePasien AS noRM, c.noBPJS, c.noHpPasien1 AS noTelp, tanggalSep, a.idJenisPerawatan
		  ,a.kodeKelasBPJS, a.kodeFaskes +'#'+ g.faskes AS kodeFaskes, g.faskes, a.tanggalRujukan
		  , a.nomorRujukan, a.kodePpkRujukan +'#'+ f.ppkRujukan AS kodePpkRujukan, f.ppkRujukan, catatan
		  ,b.ICD +'#'+ b.diagnosa AS kodeIcd, b.diagnosa, a.kodePoli +'#'+ h.poli AS kodePoli, h.poli, a.eksekutif
		  ,a.cob, a.katarak, a.lakaLantas, d.penjamin, a.tanggalKejadian, a.keterangan, a.suplesi, a.sepSuplesi
		  ,ea.kodePropinsi +'#'+ eb.propinsi AS kodePropinsi, eb.propinsi, ea.kodeKabupaten +'#'+ ea.kabupaten AS kodeKabupaten
		  ,ea.kabupaten, a.kodeKecamatan +'#'+ e.kecamatan AS kodeKecamatan, e.kecamatan, nomorSurat, a.dpjpLayan
		  ,a.kodeDpjp +'#'+ i.dpjp AS kodeDpjp, i.dpjp, a.idJenisLaka
	  FROM dbo.bpjsSep a
		   LEFT JOIN dbo.masterICD b ON a.idMasterICD = b.idMasterICD
		   LEFT JOIN dbo.masterPasien c ON a.idPasien = c.idPasien
		   OUTER APPLY (SELECT STUFF((SELECT ','+ CAST(xa.kodePenjamin AS varchar(50))
										FROM dbo.bpjsSepPenjaminLakalantas xa
									   WHERE xa.idSep = @idSep
				  FOR XML PATH ('')), 1, 1, '') AS penjamin) d
		   LEFT JOIN dbo.bpjsMasterKecamatan e ON a.kodeKecamatan = e.kodeKecamatan
				LEFT JOIN dbo.bpjsMasterkabupaten ea ON e.kodeKabupaten = ea.kodeKabupaten
				LEFT JOIN dbo.bpjsMasterPropinsi eb ON ea.kodePropinsi = eb.kodePropinsi
		   LEFT JOIN dbo.bpjsMasterPpk f ON a.kodePpkRujukan = f.kodePpkRujukan
		   LEFT JOIN dbo.bpjsMasterFaskes g ON a.kodeFaskes = g.kodeFaskes
		   LEFT JOIN dbo.bpjsMasterPoli h ON a.kodePoli = h.kodePoli
		   LEFT JOIN dbo.bpjsMasterDpjp i ON a.kodeDpjp = i.kodeDpjp
	 WHERE a.idSep = @idSep;
END