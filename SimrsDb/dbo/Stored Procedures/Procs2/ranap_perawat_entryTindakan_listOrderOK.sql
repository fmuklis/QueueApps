-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ranap_perawat_entryTindakan_listOrderOK]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idTransaksiOrderOK, a.idStatusOrderOK, CAST(a.tglOrder AS DATE) AS tglOrder, b.Alias, c.statusOperasi AS [status]
	  FROM dbo.transaksiOrderOK a
		   LEFT JOIN dbo.masterRuangan b On a.idRuanganAsal = b.idRuangan
		   LEFT JOIN dbo.masterStatusRequestOK c On a.idStatusOrderOK = c.idStatusOrderOK
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien
END