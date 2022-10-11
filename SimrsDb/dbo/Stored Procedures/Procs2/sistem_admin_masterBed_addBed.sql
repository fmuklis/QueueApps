-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Muklis F>
-- Create date: <Create 20,07,2018>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[sistem_admin_masterBed_addBed]
	-- Add the parameters for the stored procedure here
	@idRuanganRawatInap int,
	@idJenisPelayananRawatInap int,
	@noTempatTidur int,
	@tanggalMulaiDigunakan date,
	@keteranganTempatTidur nvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	IF EXISTS(SELECT 1 FROM dbo.masterRuanganTempatTidur WHERE idRuanganRawatInap = @idRuanganRawatInap AND noTempatTidur = @noTempatTidur)
		BEGIN
			SELECT 'Data Ruangan '+ namaRuanganRawatInap +' Bed: '+ CAST(@noTempatTidur AS varchar(50)) +' Telah Terdaftar' AS respon, 0 AS responCode
			  FROM dbo.masterRuanganRawatInap
			 WHERE idRuanganRawatInap = @idRuanganRawatInap;
		END
	ELSE
		BEGIN
			/*Tambah Data Bed*/
			INSERT INTO [dbo].[masterRuanganTempatTidur]
					   ([idRuanganRawatInap]
					   ,[noTempatTidur]
					   ,[flagMasihDigunakan]
					   ,[tanggalDigunakan]
					   ,[keteranganTempatTidur])
				 VALUES
					   (@idRuanganRawatInap
					   ,@noTempatTidur 
					   ,1/*Aktif*/
					   ,@tanggalMulaiDigunakan
					   ,@keteranganTempatTidur);

			/*Update Default Jenis Pelayanan*/
			UPDATE dbo.masterRuanganRawatInap
			   SET idJenisPelayananRawatInap = @idJenisPelayananRawatInap
			 WHERE idRuanganRawatInap = @idRuanganRawatInap AND idJenisPelayananRawatInap <> @idJenisPelayananRawatInap;

			SELECT 'Data Ruangan '+ namaRuanganRawatInap +' Bed: '+ CAST(@noTempatTidur AS varchar(50)) +' Berhasil Disimpan' AS respon, 1 AS responCode
			  FROM dbo.masterRuanganRawatInap
			 WHERE idRuanganRawatInap = @idRuanganRawatInap;
		END
END