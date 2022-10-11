-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_masterPemeriksaanLaboratorium_addPemeriksaaan]
	-- Add the parameters for the stored procedure here
	@idJenisPemeriksaanLaboratorium tinyint,
	@idMasterTarifHeader int,
	@nomorUrut tinyint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.masterLaboratoriumPemeriksaan WHERE idMasterTarifHeader = @idMasterTarifHeader)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Pemeriksaan Telah Terdaftar Pada Jenis'+ b.jenisPemeriksaan AS respon, 0 AS responCode
			  FROM dbo.masterLaboratoriumPemeriksaan a
				   LEFT JOIN dbo.masterLaboratoriumPemeriksaanJenis b ON a.idJenisPemeriksaanLaboratorium = b.idJenisPemeriksaanLaboratorium
			 WHERE a.idMasterTarifHeader = @idMasterTarifHeader;
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[masterLaboratoriumPemeriksaan]
					   ([idJenisPemeriksaanLaboratorium]
					   ,[idMasterTarifHeader]
					   ,[nomorUrut])
				 VALUES
					   (@idJenisPemeriksaanLaboratorium
					   ,@idMasterTarifHeader
					   ,@nomorUrut);

			SELECT 'Data Pemeriksaan Laboratorium Berhasil Disimpan' AS respon, 1 AS responCode;
		END
END