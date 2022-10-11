-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_petugasFarmasi_stokOpnameBhp_editStokOpname]
	-- Add the parameters for the stored procedure here
	@idStokOpname bigint,
	@idPeriodeStokOpname int,
    @idPetugas int,
    @tanggalStokOpname date,
    @idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiStokOpname WHERE idStokOpname = @idStokOpname AND idStatusStokOpname <> 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Diedit, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiStokOpname a
				   LEFT JOiN dbo.farmasiMasterStatusStokOpname b ON a.idStatusStokOpname = b.idStatusStokOpname
			 WHERE a.idStokOpname = @idStokOpname;
		END
	ELSE
		BEGIN
			UPDATE [dbo].[farmasiStokOpname]
			   SET [idPeriodeStokOpname] = @idPeriodeStokOpname
				  ,[idPetugas] = @idPetugas
				  ,[tanggalStokOpname] = @tanggalStokOpname
				  ,[idUserEntry] = @idUserEntry
			 WHERE idStokOpname = @idStokOpname;

			SELECT 'Data Stok Opname Berhasil Diupdate' AS respon, 1 AS responCode;
		END

END