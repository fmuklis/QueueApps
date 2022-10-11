-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_listKelasKamarPindahTitipInap] 
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idKelasPenjamin int
		   ,@idKelas int;
	SELECT @idKelasPenjamin = idKelasPenjaminPembayaran, @idKelas = idKelas 
	  FROM dbo.transaksiPendaftaranPasien
	 WHERE idPendaftaranPasien = @idPendaftaranPasien;
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT namaKelas, idKelas
	  FROM dbo.masterKelas
	 WHERE idKelas IN(@idKelas, @idKelasPenjamin) OR (pelayanan = 1 AND penjamin = 0)
END