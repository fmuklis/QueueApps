-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_returResepDetail_dataPasien]
	-- Add the parameters for the stored procedure here
	@idResep bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ba.noRM, ba.namaPasien, ba.namaJenisKelamin, ba.noDokumenIdentitasPasien, ba.tglLahirPasien, ba.umur, ba.alamatPasien
	  FROM dbo.farmasiResep a
		   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
				OUTER APPLY dbo.getInfo_dataPasien(b.idPasien) ba
	 WHERE a.idResep = @idResep
END