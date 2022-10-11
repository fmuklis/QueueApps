-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[rajal_perawatPoli_perawatanPasien_listDaftarPasien]
	-- Add the parameters for the stored procedure here
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPendaftaranPasien, a.tglDaftarPasien, b.noRM, b.namaPasien, fa.namaJenisPenjaminInduk
		  ,Case
				When Exists(Select 1 From transaksiDiagnosaPasien Where idPendaftaranPasien = a.idPendaftaranPasien)
					 Then 1
				Else 0
			End As flagDiagnosa
		  ,Case
				When a.idStatusPendaftaran IN(2,3) AND d.idTransaksiOrderOK IS Null
					 Then 1
				Else 0
			End As btnEntryTindakan
		  ,Case
				When a.idStatusPendaftaran IN(2,3) AND d.idTransaksiOrderOK is Null
					Then 1
				Else 0
			End As btnBtlTerima
		   ,Case
				When d.idTransaksiOrderOK is Null
					Then 0
				Else 1
			End As btnBtlOk
		  ,Case
				When a.idStatusPendaftaran = 4
					 Then 1
				Else 0
			End As btnBtlOrderRaNap
		  ,Case
				When a.idStatusPendaftaran = 98
					 Then 1
				Else 0
			End As btnBtlBilling
		  ,Case
				When a.idStatusPendaftaran = 99 And f.idJenisPenjaminInduk = 2/*BPJS*/
					 Then 1
				Else 0
			End As btnBtlPulang
	  FROM dbo.transaksiPendaftaranPasien a 
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
		   Inner Join dbo.masterJenisPenjaminPembayaranPasien f On a.idJenisPenjaminPembayaranPasien = f.idJenisPenjaminPembayaranPasien
				Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk fa On f.idJenisPenjaminInduk = fa.idJenisPenjaminInduk
		   Left Join dbo.transaksiOrderOK d On a.idPendaftaranPasien = d.idPendaftaranPasien
	 WHERE a.idRuangan = @idRuangan And (idStatusPendaftaran In(2,4,98) Or (idStatusPendaftaran = 99 And f.idJenisPenjaminInduk = 2/*BPJS*/ And Convert(date, a.tglDaftarPasien) = Convert(date, GetDate())))
  ORDER BY a.tglDaftarPasien
END