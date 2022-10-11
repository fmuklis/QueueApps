-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_gudangFarmasi_penghapusBarangExpired_addPenghapusanBarang]
	-- Add the parameters for the stored procedure here
	@tanggalPenghapusan date,
	@idPemohon int,
	@idUserEntry int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @idPenghapusanStok bigint = (SELECT idPenghapusanStok FROM dbo.farmasiPenghapusanStok 
										WHERE tanggalPenghapusan = @tanggalPenghapusan AND idStatusPenghapusan = 1 /* Entry Penghapusan*/)

    -- Insert statements for procedure here
	IF @idPenghapusanStok IS NULL
		BEGIN
			INSERT INTO [dbo].[farmasiPenghapusanStok]
				   ([tanggalPenghapusan]
				   ,[idPetugas]
				   ,[idStatusPenghapusan]
				   ,[idUserEntry])
			 VALUES
				   (@tanggalPenghapusan
				   ,@idPemohon
				   ,1 /* Entry Penghapusan */
				   ,@idUserEntry)
			SET @idPenghapusanStok = SCOPE_IDENTITY();
		END
	SELECT @idPenghapusanStok AS idPenghapusanStok;
END