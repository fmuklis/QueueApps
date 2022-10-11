-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
create PROCEDURE [dbo].[ranap_perawat_entryTindakan_listOrderByIdPendaftaran]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.[idOrder], a.idStatusOrder, c.namaStatusOrder, ba.namaMasterPelayanan, a.kodeOrder
	  FROM [dbo].[transaksiOrder] a 
		   Inner Join dbo.masterRuanganPelayanan b On a.idRuanganTujuan = b.idRuangan
		   Inner Join dbo.masterPelayanan ba On b.idMasterPelayanan = ba.idMasterPelayanan
		   Inner Join dbo.masterStatusOrder c On a.idStatusOrder = c.idStatusOrder
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
  ORDER BY ba.namaMasterPelayanan
END