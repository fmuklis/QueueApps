-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingRadiologiPasienLuar_listBHPTindakan]
	-- Add the parameters for the stored procedure here
	@idTindakanPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.idPenjualanDetail, a.idTindakanPasien, c.namaRuangan As ruanganTindakan, b.namaBHP, b.tarifBHP, b.jmlBHP, b.jmlTarifBHP
	  FROM dbo.transaksiTindakanPasien a
		   Cross Apply dbo.getInfo_bhpTindakan(a.idTindakanPasien) b
		   Inner join dbo.masterRuangan c On a.idRuangan = c.idRuangan
	 WHERE a.idTindakanPasien = @idTindakanPasien;
END