-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_hasilPemeriksaanLaboratoriumEdit_listPemeriksaan]
	-- Add the parameters for the stored procedure here
	@idOrder bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ca.idDetailItemPemeriksaanLaboratorium, cb.namaTarifHeader AS pemeriksaan, ca.itemPemeriksaan
		  ,ca.detailItemPemeriksaan, d.nilai, ca.satuan, ca.nilaiRujukan, d.valid
	  FROM dbo.transaksiTindakanPasien a
		   INNER JOIN dbo.transaksiOrderDetail b ON a.idOrderDetail = b.idOrderDetail
		   LEFT JOIN dbo.masterTarip c ON a.idMasterTarif = c.idMasterTarif
				OUTER APPLY dbo.getInfo_pemeriksaanLaboratorium(c.idMasterTarifHeader) ca
				LEFT JOIN dbo.masterTarifHeader cb ON c.idMasterTarifHeader = cb.idMasterTarifHeader
		   LEFT JOIN dbo.transaksiPemeriksaanLaboratorium d ON a.idTindakanPasien = d.idTindakanPasien
					 AND ca.idDetailItemPemeriksaanLaboratorium = d.idDetailItemPemeriksaanLaboratorium
	 WHERE b.idOrder = @idOrder
  ORDER BY ca.nomorUrutGolongan, ca.nomorUrutJenis, ca.nomorUrutPemeriksaan, ca.nomorUrutItemPemeriksaan, ca.nomorUrutDetailPemeriksaan
END