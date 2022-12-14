-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiOrderSelectLaporan]
	-- Add the parameters for the stored procedure here
	 @idRuanganPetugas int
	,@idStatusOrder int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
			SELECT 
	
			-- PASIEN --  
			Substring(c.[kodePasien],1,2)+'.'+Substring(c.[kodePasien],3,2)++'.'+Substring(c.[kodePasien],5,2) as kodePasien
			,case 
				when c.idJenisKelaminPasien = 2 and idStatusPerkawinanPasien in (2,3) then  c.namaLengkapPasien + '. NY BINTI ' + c.namaAyahPasien
				when c.idJenisKelaminPasien = 2 and idStatusPerkawinanPasien in (1) and DATEDIFF(hour,tglLahirPasien,GETDATE())/8766>16 then  c.namaLengkapPasien + '. NN BINTI ' + c.namaAyahPasien
				when c.idJenisKelaminPasien = 2 and idStatusPerkawinanPasien in (1) and DATEDIFF(hour,tglLahirPasien,GETDATE())/8766< = 16 then c.namaLengkapPasien + '. AN BINTI ' + c.namaAyahPasien
	
				when c.idJenisKelaminPasien = 1 and idStatusPerkawinanPasien in (2,3) then c.namaLengkapPasien + '. TN BIN ' + c.namaAyahPasien
				when c.idJenisKelaminPasien = 1 and idStatusPerkawinanPasien in (1) and DATEDIFF(hour,tglLahirPasien,GETDATE())/8766>16 then c.namaLengkapPasien + '. TN BIN ' + c.namaAyahPasien
				when c.idJenisKelaminPasien = 1 and idStatusPerkawinanPasien in (1) and DATEDIFF(hour,tglLahirPasien,GETDATE())/8766< = 16 then  c.namaLengkapPasien + '. AN BIN ' + c.namaAyahPasien	
			 End
				as  [namaLengkapPasien]

			,c.[gelarBelakangPasien],d.namaRuangan as AsalRuangan,ba.namaJenisPendaftaran,e.NamaOperator as Dokter,a.tglOrder,f.namaJenisPerawatan
			  
			  FROM [dbo].transaksiOrder a 
						Inner Join [transaksiPendaftaranPasien] b On a.idPendaftaranPasien = b.idPendaftaranPasien
							Inner Join masterJenisPendaftaran ba On b.idJenisPendaftaran = ba.idJenisPendaftaran
						Inner join [dbo].[masterPasien] c on b.[idPasien] = c.[idPasien]
							Inner Join masterRuangan d On a.idRuanganAsal = d.idRuangan
						Inner Join masterOperator e On a.idDokter = e.idOperator
						Inner Join masterJenisPerawatan f On b.idJenisPerawatan = f.idJenisPerawatan
						Inner Join transaksiTindakanPasien g On a.idPendaftaranPasien = g.idPendaftaranPasien And a.idRuanganTujuan = g.idRuangan
			  Where a.idRuanganTujuan = @idRuanganPetugas And a.idStatusOrder = @idStatusOrder
			  Order By a.idStatusOrder,a.tglOrder;
END