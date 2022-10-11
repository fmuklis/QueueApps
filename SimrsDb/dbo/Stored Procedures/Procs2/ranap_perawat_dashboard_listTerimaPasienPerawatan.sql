-- =============================================
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Daftar Pasien Permintaan Perawatan
-- =============================================
CREATE PROCEDURE [dbo].[ranap_perawat_dashboard_listTerimaPasienPerawatan]	
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    /*Make Variable*/
	DECLARE @currentDate date = GETDATE();

	SELECT a.idPendaftaranPasien, a.tglDaftarPasien, b.noRM, b.namaPasien, d.penjamin AS namaJenisPenjaminInduk
		  ,c.kamarInap AS kamar
		  /*,Case
				When Exists(Select 1 From transaksiDiagnosaPasien Where idPendaftaranPasien=a.idPendaftaranPasien)
					 Then 1
				Else 0
			End As flagDiagnosa*/
		  ,Case
				When a.idStatusPendaftaran In(2,5)
					 Then 1
				Else 0
			End As btnEntryTindakan
		  ,Case
				When a.idStatusPendaftaran In(2,5)
					 Then 1
				Else 0
			End As btnBtlTerima
		  ,Case
				When a.idStatusPendaftaran = 6
					 Then 1
				Else 0
			End As btnBtlOrderPindahKamar
		  ,Case
				When a.idStatusPendaftaran = 98 AND d.idJenisPenjaminInduk = 1/*UMUM*/
					 Then 1
				Else 0
			End As btnBtlBilling
		  ,Case
				When a.idStatusPendaftaran >= 98 And d.idJenisPenjaminInduk = 2/*BPJS*/
					 Then 1
				Else 0
			End As btnBtlPulang
	  FROM dbo.transaksiPendaftaranPasien a 
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
		   OUTER APPLY dbo.getInfo_dataRawatInap(a.idPendaftaranPasien) c
		   OUTER APPLY dbo.getInfo_penjamin(a.idJenisPenjaminPembayaranPasien) d
	 WHERE a.idRuangan = @idRuangan AND (a.idStatusPendaftaran In(2,5,6,98)
		   OR (a.idStatusPendaftaran = 99 AND d.idJenisPenjaminInduk = 2/*BPJS*/ AND a.tanggalModifikasi >= DATEADD(DAY, -3, @currentDate)))
  ORDER BY a.tglDaftarPasien Desc
END