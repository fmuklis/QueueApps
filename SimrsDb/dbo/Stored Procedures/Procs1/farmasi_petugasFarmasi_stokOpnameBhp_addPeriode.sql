-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_stokOpnameBhp_addPeriode]
	-- Add the parameters for the stored procedure here
	@tahun smallint,
	@bulan tinyint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiMasterPeriodeStokOpname WHERE tahun = @tahun AND bulan = @bulan)
		BEGIN
			SELECT 'Periode Stok Opname '+ CAST(@tahun AS varchar(10)) +' - '+ CAST(@bulan AS varchar(10)) +' Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[farmasiMasterPeriodeStokOpname]
					   ([tahun]
					   ,[bulan])
				 VALUES
					   (@tahun
					   ,@bulan);

			SELECT 'Periode Stok Opname Berhasil Disimpan' AS respon, 1 AS responCode;
		END
END