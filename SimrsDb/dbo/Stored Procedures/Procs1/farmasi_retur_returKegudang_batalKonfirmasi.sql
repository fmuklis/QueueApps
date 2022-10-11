-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_returKegudang_batalKonfirmasi]
	-- Add the parameters for the stored procedure here
	@idRetur bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiRetur WHERE idRetur = @idRetur AND idStatusRetur <> 10/*Request Confirm*/)
		BEGIN
			SELECT 'Tidak Dapat Dibatalkan, '+ b.caption
			  FROM dbo.farmasiRetur a
				   LEFT JOIN dbo.farmasiMasterStatusRetur b ON a.idStatusRetur = b.idStatusRetur
			 WHERE a.idRetur = @idRetur;
		END
	ELSE
		BEGIN
			UPDATE farmasiRetur
			   SET idStatusRetur = 5/*Request Valid*/
				  ,idPenerima = NULL
				  ,tanggalModifikasi = NULL
			 WHERE idRetur = @idRetur;

			SELECT 'Permintaan Retur Barang Farmasi Batal Dikonfirmasi' AS respon, 1 AS responCode;
		END
END