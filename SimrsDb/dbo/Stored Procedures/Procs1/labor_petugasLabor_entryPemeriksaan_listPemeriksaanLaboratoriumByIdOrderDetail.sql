-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_petugasLabor_entryPemeriksaan_listPemeriksaanLaboratoriumByIdOrderDetail]
	-- Add the parameters for the stored procedure here
	@idOrderDetail bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idMasterTarif, bb.namaTarif +' ('+ bb.kelasTarif +')' AS namaTarif, bb.BHP, bb.satuanTarif
		  ,Case
				When ba.idSatuanTarif = 4/*Jasa*/
					 Then 0
				Else 1
			End As flagQty
	  FROM dbo.transaksiOrderDetail a
		   LEFT JOIN dbo.masterTarip b ON a.idMasterTarif = b.idMasterTarif
				LEFT JOIN dbo.masterTarip ba ON b.idMasterTarifHeader = ba.idMasterTarifHeader
				OUTER APPLY dbo.getInfo_tarif(ba.idMasterTarif) bb
				LEFT JOIN dbo.masterRuanganPelayanan bc ON b.idMasterPelayanan = bc.idMasterPelayanan
	 WHERE bc.idRuangan = 21/*Laboratorium*/ AND a.idOrderDetail = @idOrderDetail
  ORDER BY bb.kelasTarif, bb.namaTarif
END