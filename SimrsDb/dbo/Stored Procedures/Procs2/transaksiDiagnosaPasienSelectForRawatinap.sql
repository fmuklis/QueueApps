-- =============================================
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Daftar Pasien Yang Telah Didiagnosa Untuk Ditindak Di Rawat Inap
-- =============================================
CREATE PROCEDURE [dbo].[transaksiDiagnosaPasienSelectForRawatinap]
	-- Add the parameters for the stored procedure here
	@idRuangan int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*SELECT a.idPendaftaranPasien 
		  ,c.kodePasien ,c.noRM ,c.namaPasien ,c.umur ,c.jenisKelamin
		  ,ba.namaRuanganRawatInap ,bb.noTempatTidur
		  ,Convert(varchar,a.tglEntry,108) as jamDaftar
		  ,Case --Tanda Jika Pasien Telah Ditindak
				When (Select Top 1 1 From transaksiTindakanPasien x Where x.idPendaftaranPasien = a.idPendaftaranPasien And x.idRuangan = a.idRuangan) = 1
					Then 1
					Else 0
		   End as flagTindakan
	  FROM dbo.transaksiPendaftaranPasien a
		   Inner Join dbo.transaksiPendaftaranPasienDetail b On a.idPendaftaranPasien = b.idPendaftaranPasien
				Inner Join dbo.masterRuanganRawatInap ba On b.idRuangan = ba.idRuanganRawatInap
				Inner Join dbo.masterRuanganTempatTidur bb On ba.idRuanganRawatInap = bb.idRuanganRawatInap
		   Inner Join (Select * From dbo.dataPasien()) c On a.idPasien = c.idPasien
		   Inner Join dbo.masterRuangan d On a.idRuangan = d.idRuangan
	 WHERE a.idStatusPendaftaran = 2 And idOrderRawatInap = 4 And a.idRuangan = @idRuangan
--  GROUP BY a.idPendaftaranPasien ,a.idOperator ,c.NamaOperator ,da.kodePasien ,da.noRM ,da.namaPasien ,da.umur ,da.jenisKelamin ,db.namaRuangan ,d.tglEntry
  ORDER BY a.tglEntry*/
END