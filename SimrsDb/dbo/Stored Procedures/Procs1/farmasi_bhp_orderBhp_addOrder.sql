-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_bhp_orderBhp_addOrder]
	-- Add the parameters for the stored procedure here
	@idRuangan int,
	@idJenisStokAsal int,
	@idUserEntry int,
	@tglMutasi date,
	@keterangan varchar(max)
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idMutasi int;
	 SELECT @idMutasi = idMutasi 
	   FROM dbo.farmasiMutasi 
	  WHERE idJenisMutasi = 2/*Mutasi BHP*/ AND idJenisStokAsal = @idJenisStokAsal AND tanggalOrder = @tglMutasi AND idStatusMutasi = 1/*Permintaan Mutasi*/ AND idRuangan = @idRuangan;
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF @idMutasi IS NULL
		BEGIN
			INSERT INTO [dbo].[farmasiMutasi]
					   ([idJenisStokAsal]
					   ,[idJenisStokTujuan]
					   ,[idRuangan]
					   ,[idJenisMutasi]
					   ,[nomorOrder]
					   ,[idUserEntry]
					   ,[tanggalOrder]
					   ,[keterangan])
				 VALUES
					   (@idJenisStokAsal
					   ,6/*Stok BHP Ruangan*/
					   ,@idRuangan
					   ,2/*Mutasi BHP*/
					   ,dbo.generate_nomorOrderBhp(@tglMutasi)
					   ,@idUserEntry
					   ,@tglMutasi
					   ,@keterangan);

			SELECT SCOPE_IDENTITY() AS idMutasi;
		END
	ELSE
		BEGIN
			SELECT @idMutasi AS idMutasi;
		END
END