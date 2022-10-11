-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_stokOpnameBhpDetail_addKoreksiStokOpname]
	-- Add the parameters for the stored procedure here
	@idStokOpname bigint,
	@idObatDetail int,
	@jumlahStokOpname decimal(18,2),
	@keterangan nvarchar(max),
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiStokOpname WHERE idStokOpname = @idStokOpname AND idStatusStokOpname <> 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiStokOpname a
				   LEFT JOIN dbo.farmasiMasterStatusStokOpname b ON a.idStatusStokOpname = b.idStatusStokOpname
			 WHERE a.idStokOpname = @idStokOpname;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiStokOpnameDetail WHERE idStokOpname = @idStokOpname AND idObatDetail = @idObatDetail)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Item Koreksi Stok BHP Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[farmasiStokOpnameDetail]
					   ([idStokOpname]
					   ,[idJenisStokOpname]
					   ,[idObatDetail]
					   ,[idObatDosis]
					   ,[kodeBatch]
					   ,[tglExpired]
					   ,[jumlahAwal]
					   ,[jumlahStokOpname]
					   ,[keterangan]
					   ,[idUserEntry])
				 SELECT @idStokOpname
					   ,2/*Koreksi Stok*/
					   ,@idObatDetail
					   ,a.idObatDosis
					   ,a.kodeBatch
					   ,a.tglExpired
					   ,a.stok
					   ,@jumlahStokOpname
					   ,@keterangan
					   ,@idUserEntry
				   FROM dbo.farmasiMasterObatDetail a
				  WHERE a.idObatDetail = @idObatDetail;

			SELECT 'Data Koreksi Stok BHP Berhasil Disimpan' AS respon, 1 AS responCode;
		END
END