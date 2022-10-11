-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laboratorium_pemeriksaan_entryTindakan_listPemeriksaanPasienLuar]
	-- Add the parameters for the stored procedure here
	@idOrder bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.idTindakanPasien, b.idOrderDetail, c.idPenjualanDetail, ba.namaTarif, ba.jmlTarif, ba.kelasTarif, ba.BHP ,c.namaBHP, c.jmlBHP, c.tarifBHP, c.jmlTarifBHP
	  FROM dbo.transaksiOrderDetail a
				Inner Join dbo.transaksiTindakanPasien b On a.idOrderDetail = b.idOrderDetail
				Outer Apply dbo.getinfo_tarifTindakan(b.idTindakanPasien) ba
				Outer Apply dbo.getinfo_bhpTindakan(b.idTindakanPasien) c
	 WHERE a.idOrder = @idOrder;
END