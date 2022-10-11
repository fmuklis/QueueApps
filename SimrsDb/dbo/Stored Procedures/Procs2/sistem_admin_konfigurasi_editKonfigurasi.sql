-- =============================================
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Menampilkan Operator Berdasarkan Jenisnya
-- =============================================
CREATE PROCEDURE [dbo].[sistem_admin_konfigurasi_editKonfigurasi]
	-- Add the parameters for the stored procedure here
	@persentaseHargaJualFarmasi int,
	@idPenanggungJawabLaboratorium int,
	@bhpDitagihkan bit

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.masterKonfigurasi)
		BEGIN
			UPDATE dbo.masterKonfigurasi
			   SET persentaseHargaJualFarmasi = @persentaseHargaJualFarmasi
				  ,idPenanggungJawabLaboratorium = @idPenanggungJawabLaboratorium
				  ,bhpDitagihkan = @bhpDitagihkan

			SELECT 'Konfigurasi Sistem Berhasil Diupdate' AS respon, 1 AS responCode
		END
	ELSE
		BEGIN
			INSERT INTO dbo.masterKonfigurasi
					   (persentaseHargaJualFarmasi
					   ,idPenanggungJawabLaboratorium
					   ,bhpDitagihkan)
				 VALUES
					   (@persentaseHargaJualFarmasi
					   ,@idPenanggungJawabLaboratorium
					   ,@bhpDitagihkan)

			SELECT 'Konfigurasi Sistem Berhasil Disimpan' AS respon, 1 AS responCode
		END
END