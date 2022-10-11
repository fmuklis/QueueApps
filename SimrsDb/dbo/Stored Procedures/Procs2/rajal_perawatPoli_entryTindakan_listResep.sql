-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[rajal_perawatPoli_entryTindakan_listResep]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idRuangan int = (Select idRuangan From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select a.idResep, b.idResepDetail, b.idRacikan, a.idStatusResep, a.tglResep, a.noResep, ba.namaBarang, b.jumlah, ba.namaSatuanObat
		  ,Case
				When b.idRacikan = 0
					 Then 'Non Racikan'
				Else 'Racikan'
			End As jenisResep
		  ,Cast(b.kaliKonsumsi As nchar(10)) +' X '+ Cast(b.jumlahKonsumsi As nchar(10)) +' '+ bb.namaTakaran +' '+ bc.namaResepWaktu +' '+ bd.saatKonsumsi As aturanPakai, b.keterangan
	  From dbo.farmasiResep a
		   Inner Join dbo.farmasiResepDetail b On a.idResep = b.idResep
				Cross Apply dbo.getInfo_barangFarmasi(b.idObatDosis) ba
				Left Join dbo.farmasiResepTakaran bb On b.idTakaran = bb.idTakaran
				Left Join dbo.farmasiResepWaktu bc On b.idResepWaktu = bc.idResepWaktu
				Left Join dbo.farmasiResepSaatKonsumsi bd On b.idSaatKonsumsi = bd.idSaatKonsumsi
	 Where a.idPendaftaranPasien = @idPendaftaranPasien And a.idRuangan = @idRuangan
END