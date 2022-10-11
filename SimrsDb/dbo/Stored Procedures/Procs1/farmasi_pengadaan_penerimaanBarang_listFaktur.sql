-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_pengadaan_penerimaanBarang_listFaktur]
	-- Add the parameters for the stored procedure here
	@idorder bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPembelianHeader, a.noFaktur, a.tglPembelian, a.tglJatuhTempoPembayaran, a.keterangan, a.ppn
		  ,CASE
				WHEN a.idStatusPembelian = 1
					 THEN 1
				ELSE 0
			END AS btnDetail
		  ,CASE
				WHEN a.idStatusPembelian = 1
					 THEN 1
				ELSE 0
			END AS btnEdit
		  ,CASE
				WHEN a.idStatusPembelian = 1
					 THEN 1
				ELSE 0
			END AS btnDelete
		  ,CASE
				WHEN a.idStatusPembelian = 2 AND b.tanggalModifikasi = CAST(GETDATE() AS date)
					 THEN 1
				ELSE 0
			END AS btnBatalValidasi
		  ,CASE
				WHEN a.idStatusPembelian = 2
					 THEN 1
				ELSE 0
			END AS btnCetak
	  FROM dbo.farmasiPembelian a
		   LEFT JOIN dbo.farmasiOrder b ON a.idOrder = b.idOrder
	 WHERE a.idOrder = @idorder
  ORDER BY a.tglPembelian, a.noFaktur
END