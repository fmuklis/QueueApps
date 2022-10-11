-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_bhp_orderBhpDetail_validasi]
	-- Add the parameters for the stored procedure here
	@idMutasi bigint
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiMutasi WHERE idMutasi = @idMutasi AND idStatusMutasi <> 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Divalidasi, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiMutasi a
				   LEFT JOIN dbo.farmasiMasterStatusMutasi b ON a.idStatusMutasi = b.idStatusMutasi
			 WHERE a.idMutasi = @idMutasi;
		END
	ELSE IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.farmasiMutasiOrderItem WHERE idMutasi = @idMutasi)
		BEGIN
			SELECT 'Tidak Dapat Divalidasi, Item Request BHP Belum Dientry' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			UPDATE [dbo].[farmasiMutasi]
			   SET idStatusMutasi = 2/*Request BHP Divalidasi*/
			 WHERE idMutasi = @idMutasi;

			SELECT 'Data Item Permintaan BHP Berhasil Divalidasi' AS respon, 1 AS responCode;
		END
END