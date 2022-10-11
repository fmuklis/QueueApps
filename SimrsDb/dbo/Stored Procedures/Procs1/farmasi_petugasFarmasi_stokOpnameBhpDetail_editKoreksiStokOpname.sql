-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_stokOpnameBhpDetail_editKoreksiStokOpname]
	-- Add the parameters for the stored procedure here
	@idStokOpnameDetail bigint,
	@jumlahStokOpname decimal(18,2),
	@keterangan nvarchar(max),
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idStokOpname bigint = (SELECT idStokOpname FROM dbo.farmasiStokOpnameDetail
									 WHERE idStokOpnameDetail = @idStokOpnameDetail);
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiStokOpname WHERE idStokOpname = @idStokOpname AND idStatusStokOpname <> 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiStokOpname a
				   LEFT JOIN dbo.farmasiMasterStatusStokOpname b ON a.idStatusStokOpname = b.idStatusStokOpname
			 WHERE a.idStokOpname = @idStokOpname;
		END
	ELSE
		BEGIN
			UPDATE [dbo].[farmasiStokOpnameDetail]
			   SET [jumlahStokOpname] = @jumlahStokOpname
				  ,[keterangan] = @keterangan
				  ,[idUserEntry] = @idUserEntry
			 WHERE idStokOpnameDetail = @idStokOpnameDetail;

			SELECT 'Data Koreksi Stok BHP Berhasil Diupdate' AS respon, 1 AS responCode;
		END
END