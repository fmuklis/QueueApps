-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_bhp_orderBhp_batalValidasi]
	-- Add the parameters for the stored procedure here
	@idMutasi bigint
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiMutasi WHERE idMutasi = @idMutasi AND idStatusMutasi <> 2/*Request Divalidasi*/)
		BEGIN
			SELECT 'Tidak Dapat Batal Validasi, Request BHP'+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiMutasi a
				   LEFT JOIN dbo.farmasiMasterStatusMutasi b ON a.idStatusMutasi = b.idStatusMutasi
			 WHERE a.idMutasi = @idMutasi;
		END
	ELSE
		BEGIN
			UPDATE dbo.farmasiMutasi
			   SET idStatusMutasi = 1/*Proses Entry*/
			 WHERE idMutasi = @idMutasi;

			SELECT 'Validasi Permintaan BHP Berhasil Dibatalkan' AS respon, 1 AS responCode;
		END
END