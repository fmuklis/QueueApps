-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_returKegudangDetail_addPetugasPenerima]
	-- Add the parameters for the stored procedure here
	@namaPetugas varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiMasterPetugas WHERE namaPetugasFarmasi = @namaPetugas)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Petugas Farmasi Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			INSERT INTO dbo.farmasiMasterPetugas
					   (namaPetugasFarmasi)
				 VALUES 
					   (@namaPetugas);

			SELECT 'Data Petugas Farmasi Berhasil Disimpan' AS respon, 1 AS responCode;
		END
END