-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laporanPembayaranFarmasi]
	-- Add the parameters for the stored procedure here
	@periodeAwal date 
	,@periodeAkhir date
	,@idUserBayar int

WITH EXECUTE AS OWNER
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
	SET @Query = 'SELECT d.namaJenisBayar, a.tglBayar, ba.noRM, ba.namaPasien, ''Instalasi Farmasi'' As namaRuangan, c.namaLengkap
						,(Select Sum(xb.hargaJual * xb.jumlah)
							From dbo.farmasiPenjualanHeader xa
								 Inner Join dbo.farmasiPenjualanDetail xb On xa.idPenjualanHeader = xb.idPenjualanHeader
						   Where a.idResep = xa.idResep) As total
					FROM dbo.transaksiBillingHeader a
						 Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
							OUTER APPLY dbo.get_dataPasien(b.idPasien) ba
							Inner Join dbo.masterRuangan bb On b.idRuangan = bb.idRuangan
						 Inner Join dbo.masterUser c On a.idUserBayar = c.idUser
						 Inner Join dbo.masterJenisBayar d On a.idJenisBayar = d.idJenisBayar
				   WHERE a.idJenisBilling = 3/*Billing Farmasi*/ And Convert(date, a.tglBayar) Between '''+ Convert(nvarchar(50), @periodeAwal) +''' And '''+ Convert(nvarchar(50), @periodeAkhir) +''''+ @Where +'
				ORDER BY d.namaJenisBayar, a.tglBayar, bb.namaRuangan';
	EXEC (@Query);
	--SELECT @Query;
END