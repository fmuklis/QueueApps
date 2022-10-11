-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[transaksiBillingHeaderSelectByidResep]
	-- Add the parameters for the stored procedure here
	@idResep int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from

	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	/*SELECT a.[idPenjualanHeader]
		  ,a.[idResep]
		  ,[idPetugasFarmasi]
		  ,[tglJual]
		  ,a.[tglEntry]
		  ,a.[idUserEntry], 'FARMASI/APOTEK' As namaRuangan
		  --DETIL
		  ,b.[idObat]
		  ,[idRacikan]
		  ,CASE 
				When [idRacikan] = 1
					Then 'Non Racikan'
				Else 'Racikan'
			End
			As jenisObat
		  ,[jumlah]
		  --OBAT
		  ,[namaObat]
		  ,[namaSatuanObat]
		  ,ba.hargaJual as hargaJualSatuan
		  ,ba.[hargaJual]*[jumlah] as Harga
	  FROM [dbo].[farmasiPenjualanHeader] a 
		   Inner Join [dbo].[farmasiPenjualanDetail] b On a.[idPenjualanHeader] = b.[idPenjualanHeader]
				Inner Join [dbo].[farmasiMasterObat] ba On b.[idObat] = ba.[idObat]
				Inner Join [dbo].[farmasiMasterSatuanObat] bb On ba.[idSatuanObat] = bb.[idSatuanObat]
		   Inner Join dbo.farmasiResep c On a.idResep = c.idResep
				Inner Join dbo.transaksiBillingHeader ca On c.idPendaftaranPasien = ca.idPendaftaranPasien 
	 WHERE c.idResep = @idResep
  ORDER BY b.[idRacikan], [namaObat]*/
END