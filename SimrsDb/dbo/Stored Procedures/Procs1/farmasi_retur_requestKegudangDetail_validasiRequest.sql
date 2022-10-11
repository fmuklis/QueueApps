-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_requestKegudangDetail_validasiRequest]
	-- Add the parameters for the stored procedure here
	@idRetur bigint,
	@idPetugas int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiRetur WHERE idRetur = @idRetur AND idStatusRetur <> 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Divalidasi, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiRetur a
				   LEFT JOIN dbo.farmasiMasterStatusRetur b ON a.idStatusRetur = b.idStatusRetur
			 WHERE a.idRetur = @idRetur;
		END
	ELSE IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.farmasiReturDetail a
						WHERE a.idRetur = @idRetur)
		BEGIN
			SELECT 'Tidak Dapat Divalidasi, Item Barang Retur Kegudang Belum Dientry' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			/*Update Status Retur*/
			UPDATE dbo.farmasiRetur
			   SET idStatusRetur = 5/*Request Retur Valid*/
				  ,kodeRetur = dbo.generate_nomorRetur(tanggalRetur)
				  ,idPetugasRetur = @idPetugas
			 WHERE idRetur = @idRetur;

			SELECT 'Request Retur Ke Gudang Farmasi Berhasil Divalidasi' AS respon, 1 AS responCode;
		END
END