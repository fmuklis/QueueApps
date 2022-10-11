-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laporanPembayaranRaNap]
	-- Add the parameters for the stored procedure here
	@periodeAwal date 
	,@periodeAkhir date
	,@idUserBayar int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements. 
	Declare @Query nvarchar(max)
		   ,@Where nvarchar(max) = Case
										When @idUserBayar <> 0
											 Then 'And a.idUserBayar = '+ Convert(nvarchar(50), @idUserBayar) +''
										Else ''
									End

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @Query = 'SELECT d.namaJenisBayar, a.tglBayar, ba.noRM, ba.namaPasien, bb.namaRuangan, c.namaLengkap
						,(Select Sum(xb.nilai)
							From dbo.transaksiTindakanPasien xa
								 Inner Join dbo.transaksiTindakanPasienDetail xb On xa.idTindakanPasien = xb.idTindakanPasien
						   Where a.idPendaftaranPasien = xa.idPendaftaranPasien And a.idJenisBilling = xa.idJenisBilling)
						/*Biaya Kamar Inap*/
						+IsNull((Select Sum(xa.biayaInap)
							From dbo.transaksiPendaftaranPasienDetail xa
						   Where a.idPendaftaranPasien = xa.idPendaftaranPasien), 0)
						/*Biaya Farmasi*/
						+IsNull((Select Sum(xb.hargaJual * xb.jumlah)
							From dbo.farmasiPenjualanHeader xa
								 Inner Join dbo.farmasiPenjualanDetail xb On xa.idPenjualanHeader = xb.idPenjualanHeader
						   Where a.idBilling = xa.idBilling), 0) As total
					FROM dbo.transaksiBillingHeader a
						 Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
							Inner Join (Select * From dbo.dataPasien() xa) ba On b.idPasien = ba.idPasien
							Inner Join dbo.masterRuangan bb On b.idRuangan = bb.idRuangan
						 Inner Join dbo.masterUser c On a.idUserBayar = c.idUser
						 Inner Join dbo.masterJenisBayar d On a.idJenisBayar = d.idJenisBayar
				   WHERE a.idJenisBilling = 6/*Billing Rawat Inap*/ And Convert(date, a.tglBayar) Between '''+ Convert(nvarchar(50), @periodeAwal) +''' And '''+ Convert(nvarchar(50), @periodeAkhir) +''''+ @Where +'
				ORDER BY d.namaJenisBayar, a.tglBayar, bb.namaRuangan';
	EXEC (@Query);
	--SELECT @Query;
END