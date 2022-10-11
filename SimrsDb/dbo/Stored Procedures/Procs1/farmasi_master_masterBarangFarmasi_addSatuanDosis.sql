-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_master_masterBarangFarmasi_addSatuanDosis]
	-- Add the parameters for the stored procedure here
	@namaSatuanDosis varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiMasterObatSatuanDosis WHERE namaSatuanDosis = @namaSatuanDosis)
		BEGIN
			Select 'Tidak Dapat Disimpan Satuan Barang Farmasi '+ @namaSatuanDosis +' Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[farmasiMasterObatSatuanDosis]
					   ([namaSatuanDosis])
				 VALUES
					   (@namaSatuanDosis);
			
			Select 'Data Satuan Barang Farmasi Berhasil Disimpan' AS respon, 1 AS responCode;
		END
END