-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[ranap_perawat_entryTindakan_listTarip]
	-- Add the parameters for the stored procedure here
	@idRuangan int,
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @IdKelas int
		   ,@IdKelasPenjamin int
	Select @IdKelas = idKelas, @IdKelasPenjamin = idKelasPenjaminPembayaran
	  From dbo.transaksiPendaftaranPasien
	 Where idPendaftaranPasien = @idPendaftaranPasien;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idMasterTarif, c.namaTarifHeader +' ('+ d.namaKelas +')' As namaTarif, a.Keterangan, c.BHP
		  ,b.idRuangan , e.namaSatuanTarif
		  ,CASE
			WHEN a.idSatuanTarif = 4
				THEN 0
			ELSE 1
		   END AS flagQty
	  FROM dbo.masterTarip a
		   Inner Join dbo.masterRuanganPelayanan b On a.idMasterPelayanan = b.idMasterPelayanan
		   Inner Join dbo.masterTarifHeader c On a.idMasterTarifHeader = c.idMasterTarifHeader
		   Left Join dbo.masterKelas d On a.idKelas = d.idKelas		
		   Inner Join dbo.masterSatuanTarif e On a.idSatuanTarif = e.idSatuanTarif
	 WHERE a.idKelas In(@IdKelas, @IdKelasPenjamin, 99) And b.idRuangan = @idRuangan --And a.idSatuanTarif = 4/*Jasa*/
  ORDER BY c.namaTarifHeader, a.idKelas
END