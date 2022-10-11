-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laporanPasienOperasi] 
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date,
	@idPenjaminInduk int,
	@idGolonganSpesialis int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT Distinct a.tglOperasi, bb.namaJenisPenjaminInduk, bc.noRM, bc.namaPasien, bc.namaJenisKelamin As jenisKelamin, bc.tglLahirPasien, bc.umur
		  ,bc.alamatPasien, dbo.diagnosaPasien(b.idPendaftaranPasien) As diagnosa, bd.NamaOperator As DPJP, c.golonganSpesialis
		  ,d.golonganOk, e.golonganSpinal, a.jamMulai, a.jamSelesai, a.jamMulaiAnestesi, a.jamSelesaiAnestesi
		  ,f.dokterOperator, g.dokterAnestesi, h.penataAnestesi, i.perawat
	  FROM dbo.transaksiOrderOK a
		   Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				Inner Join dbo.masterJenisPenjaminPembayaranPasien ba On b.idJenisPenjaminPembayaranPasien = ba.idJenisPenjaminPembayaranPasien
				Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk bb On ba.idJenisPenjaminInduk = bb.idJenisPenjaminInduk
				Outer Apply dbo.getinfo_datapasien(b.idPasien ) bc	
				Inner Join dbo.masterOperator bd On b.idDokter = bd.idOperator  				   
		   Left Join dbo.masterOkGolonganSpesialis c on a.idGolonganSpesialis = c.idGolonganSpesialis
		   Left Join dbo.masterOkGolongan d On a.idGolonganOk = d.idGolonganOk
		   Left Join dbo.masterOkGolonganSpinal e On a.idGolonganSpinal = e.idGolonganSpinal
		   Left Join (Select xa.idTransaksiOrderOK
							,Substring((Select Distinct ' Dan '+ yd.NamaOperator
										  From dbo.transaksiTindakanPasien ya
											   Inner Join dbo.transaksiTindakanPasienDetail yb On ya.idTindakanPasien = yb.idTindakanPasien And yb.idMasterKatagoriTarip = 1/*Jasa Dokter*/          
											   Inner Join dbo.transaksiTindakanPasienOperator yc On yb.idTindakanPasienDetail = yc.idTindakanPasienDetail            
											   Inner Join dbo.masterOperator yd on yc.idOperator = yd.idOperator  
   										 Where xa.idTransaksiOrderOK = ya.idTransaksiOrderOK
								  FOR XML PATH ('')), 5, 1000) As dokterOperator
						From dbo.transaksiOrderOK xa) f On a.idTransaksiOrderOK = f.idTransaksiOrderOK
		   Left Join (Select xa.idTransaksiOrderOK
							,Substring((Select Distinct ' Dan '+ yd.NamaOperator
										  From dbo.transaksiTindakanPasien ya
											   Inner Join dbo.transaksiTindakanPasienDetail yb On ya.idTindakanPasien = yb.idTindakanPasien And yb.idMasterKatagoriTarip = 3/*Jasa Dokter Anestesi*/          
											   Inner Join dbo.transaksiTindakanPasienOperator yc On yb.idTindakanPasienDetail = yc.idTindakanPasienDetail            
											   Inner Join dbo.masterOperator yd on yc.idOperator = yd.idOperator  
   										 Where xa.idTransaksiOrderOK = ya.idTransaksiOrderOK
								  FOR XML PATH ('')), 5, 1000) As dokterAnestesi
						From dbo.transaksiOrderOK xa) g On a.idTransaksiOrderOK = g.idTransaksiOrderOK
		   Left Join (Select xa.idTransaksiOrderOK
							,Substring((Select Distinct ' Dan '+ yd.NamaOperator
										  From dbo.transaksiTindakanPasien ya
											   Inner Join dbo.transaksiTindakanPasienDetail yb On ya.idTindakanPasien = yb.idTindakanPasien And yb.idMasterKatagoriTarip = 4/*Jasa Penata Anestesi*/          
											   Inner Join dbo.transaksiTindakanPasienOperator yc On yb.idTindakanPasienDetail = yc.idTindakanPasienDetail            
											   Inner Join dbo.masterOperator yd on yc.idOperator = yd.idOperator  
   										 Where xa.idTransaksiOrderOK = ya.idTransaksiOrderOK
								  FOR XML PATH ('')), 5, 1000) As penataAnestesi
						From dbo.transaksiOrderOK xa) h On a.idTransaksiOrderOK = h.idTransaksiOrderOK
		   Left Join (Select xa.idTransaksiOrderOK
							,Substring((Select Distinct ' Dan '+ yd.NamaOperator
										  From dbo.transaksiTindakanPasien ya
											   Inner Join dbo.transaksiTindakanPasienDetail yb On ya.idTindakanPasien = yb.idTindakanPasien And yb.idMasterKatagoriTarip = 5/*Jasa Perawat*/          
											   Inner Join dbo.transaksiTindakanPasienOperator yc On yb.idTindakanPasienDetail = yc.idTindakanPasienDetail            
											   Inner Join dbo.masterOperator yd on yc.idOperator = yd.idOperator  
   										 Where xa.idTransaksiOrderOK = ya.idTransaksiOrderOK
								  FOR XML PATH ('')), 5, 1000) As perawat
						From dbo.transaksiOrderOK xa) i On a.idTransaksiOrderOK = i.idTransaksiOrderOK
	 WHERE a.tglOperasi Between @periodeAwal And @periodeAkhir And ba.idJenisPenjaminInduk = @idPenjaminInduk And c.idGolonganSpesialis = @idGolonganSpesialis
END