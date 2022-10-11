-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[farmasi_pemakaianInternal_entryPemakaianInternal_addUnit]
	-- Add the parameters for the stored procedure here
	@alias varchar(50),
	@namaUnit varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiPemakaianInternalBagian WHERE namaBagian = @namaUnit)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Unit '+ @namaUnit +' Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			INSERT INTO dbo.farmasiPemakaianInternalBagian
					   (alias
					   ,namaBagian)
				 VALUES 
					   (@alias
					   ,@namaUnit);

			SELECT 'Data Unit '+ @namaUnit +' Berhasil Disimpan' AS respon, 1 AS responCode;
		END
END