-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_bhp_orderBhpDetail_deleteItem]
	-- Add the parameters for the stored procedure here
	@idItemOrderMutasi bigint
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idMutasi bigint;

	SELECT @idMutasi = idMutasi
	  FROM dbo.farmasiMutasiOrderItem
	 WHERE idItemOrderMutasi = @idItemOrderMutasi;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiMutasi WHERE idMutasi = @idMutasi AND idStatusMutasi <> 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Dihapus, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiMutasi a
				   LEFT JOIN dbo.farmasiMasterStatusMutasi b ON a.idStatusMutasi = b.idStatusMutasi
			 WHERE a.idMutasi = @idMutasi;
		END
	ELSE
		BEGIN
			DELETE dbo.farmasiMutasiOrderItem
			 WHERE idItemOrderMutasi = @idItemOrderMutasi;

			SELECT 'Data Item Permintaan BHP Berhasil Dihapus' AS respon, 1 AS responCode;
		END
END