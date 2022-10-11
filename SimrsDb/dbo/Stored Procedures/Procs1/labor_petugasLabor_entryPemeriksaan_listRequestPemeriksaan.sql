-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_petugasLabor_entryPemeriksaan_listRequestPemeriksaan]
	-- Add the parameters for the stored procedure here
	@idOrder bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idOrderDetail, b.namaTarif, c.namaLengkap AS petugas
		  ,CASE
				WHEN d.idTindakanPasien IS NULL
					 THEN 1
				ELSE 0
			END AS btnPilih
	  FROM dbo.transaksiOrderDetail a
		   OUTER APPLY dbo.getInfo_tarif(a.idMasterTarif) b
		   LEFT JOIN dbo.masterUser c ON a.idUserEntry = c.idUser
		   LEFT JOIN dbo.transaksiTindakanPasien d ON a.idOrderDetail = d.idOrderDetail
	 WHERE a.idOrder = @idOrder
  ORDER BY b.namaTarif
END