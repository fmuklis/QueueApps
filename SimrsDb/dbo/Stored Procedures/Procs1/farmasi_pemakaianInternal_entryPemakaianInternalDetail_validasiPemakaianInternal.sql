-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[farmasi_pemakaianInternal_entryPemakaianInternalDetail_validasiPemakaianInternal]
	-- Add the parameters for the stored procedure here
	@idPemakaianInternal bigint,
	@idPetugas int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiPemakaianInternal WHERE idStatusPemakaianInternal <> 1/*Proses Entry*/
					 AND idPemakaianInternal = @idPemakaianInternal)
		BEGIN
			SELECT 'Tidak Dapat Divalidasi, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiPemakaianInternal a
				   LEFT JOIN dbo.farmasiMasterStatusPemakaianInternal b ON a.idStatusPemakaianInternal = b.idStatusPemakaianInternal
			 WHERE a.idPemakaianInternal = @idPemakaianInternal;
		END
	ELSE IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.farmasiPenjualanDetail WHERE idPemakaianInternal = @idPemakaianInternal)
		BEGIN
			SELECT 'Tidak Dapat Divalidasi, Item Pemakaian Internal Belum Dientry' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			UPDATE dbo.farmasiPemakaianInternal
			   SET [idStatusPemakaianInternal] = 5/*Valid / Selesai*/
				  ,[idPetugas] = @idPetugas
				  ,[kodePemakaianInternal] = dbo.generate_nomorPemakaianInternal(tanggalPermintaan)
				  ,[tanggalModifikasi] = GETDATE()
			 WHERE idPemakaianInternal = @idPemakaianInternal;

			SELECT 'Pemakaian Internal Berhasil Divalidasi' AS respon, 1 AS responCode;
		END
END