-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiTindakanPasienSelectByIdRuangan] 
	-- Add the parameters for the stored procedure here
	@IdRuangan int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*SELECT idTindakanPasien
		  ,idDiagNosa
		  ,CONVERT(nvarchar,b.tglEntry,108) as TglDiagnosa
		  ,ca.noRM
		  ,ca.namaPasien
		  ,ca.umur
		  ,bb.NamaOperator
		  ,ba.namaPenyakit
		  ,ba.keterangan as keteranganPenyakit
		  ,bc.namaRuangan
	  FROM dbo.transaksiTindakanPasien a 
		   Inner Join dbo.transaksiDiagnosaPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				Inner Join dbo.masterPenyakit ba On b.idPenyakit = ba.idPenyakit
				Inner Join dbo.masterOperator bb On b.idDokter = bb.idOperator
				Inner Join dbo.masterRuangan bc On b.idRuangan = bc.idRuangan
		   Inner Join dbo.transaksiPendaftaranPasien c On a.idPendaftaranPasien = c.idPendaftaranPasien
				Inner Join (Select * From dbo.dataPasien()) ca On c.idPasien = ca.idPasien
  ORDER BY b.tglEntry*/
END