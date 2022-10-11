-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Muklis F>
-- Create date: <Create 20,07,2018>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[sistem_admin_masterBed_editBed]
	-- Add the parameters for the stored procedure here
	@idTempatTidur int,
	@noTempatTidur int,
	@idRuangan int,
	@namaRuanganRawatInap nvarchar(50),
	@idKelas int,
	@idJenisPelayananRawatInap int,
	@status bit,
	@tanggalMulaiDigunakan date,
	@tanggalNonaktif date,
	@keteranganTempatTidur nvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idRuanganRawatInap int;
	
	SELECT @idRuanganRawatInap = idRuanganRawatInap
	  FROM dbo.masterRuanganTempatTidur
	 WHERE idTempatTidur = @idTempatTidur;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.masterRuanganTempatTidur WHERE idRuanganRawatInap = @idRuanganRawatInap AND noTempatTidur = @noTempatTidur AND idTempatTidur <> @idTempatTidur)
		BEGIN
			SELECT 'Data Ruangan '+ namaRuanganRawatInap +' Bed: '+ CAST(@noTempatTidur AS varchar(50)) +' Telah Terdaftar' AS respon, 0 AS responCode
			  FROM dbo.masterRuanganRawatInap
			 WHERE idRuanganRawatInap = @idRuanganRawatInap;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.masterRuanganRawatInap WHERE namaRuanganRawatInap = @namaRuanganRawatInap AND idRuanganRawatInap <> @idRuanganRawatInap)
		BEGIN
			SELECT 'Ruangan '+ @namaRuanganRawatInap +' Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			UPDATE a
			   SET [idRuangan] = @idRuangan
				  ,[namaRuanganRawatInap] = @namaRuanganRawatInap
				  ,[idKelas] = @idKelas
				  ,[idJenisPelayananRawatInap] = @idJenisPelayananRawatInap
			  FROM dbo.masterRuanganRawatInap a
				   INNER JOIN dbo.masterRuanganTempatTidur b ON a.idRuanganRawatInap = b.idRuanganRawatInap
			 WHERE b.idTempatTidur = @idTempatTidur;

			UPDATE dbo.masterRuanganTempatTidur
			   SET [noTempatTidur] = @noTempatTidur
				  ,[flagMasihDigunakan] = @status
				  ,[tanggalDigunakan] = @tanggalMulaiDigunakan
				  ,[tanggalNonaktif] = @tanggalNonaktif
				  ,[keteranganTempatTidur] = @keteranganTempatTidur
			 WHERE idTempatTidur = @idTempatTidur;

			Select 'Data Bed Kamar Inap Berhasil Diupdate' AS respon, 1 AS responCode;
		END
END