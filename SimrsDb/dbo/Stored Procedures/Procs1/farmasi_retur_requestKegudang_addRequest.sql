-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_requestKegudang_addRequest]
	-- Add the parameters for the stored procedure here
	@idUserEntry int,
	@tanggalRetur date,
	@keterangan varchar(max)
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStokAsal tinyint = (SELECT idJenisStok FROM dbo.masterRuangan a
											   INNER JOIN dbo.masterUser b ON a.idRuangan = b.idRuangan
										 WHERE b.idUser = @idUserEntry);

	DECLARE @idRetur bigint;

	 SELECT @idRetur = idRetur 
	   FROM dbo.farmasiRetur 
	  WHERE idJenisRetur = 2/*Retur Ke Gudang*/ AND idJenisStokAsal = @idJenisStokAsal AND tanggalRetur = @tanggalRetur AND idStatusRetur = 1/*Permintaan Retur*/;
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF @idRetur IS NULL
		BEGIN
			INSERT INTO [dbo].[farmasiRetur]
					   ([tanggalRetur]
					   ,[idJenisRetur]
					   ,[idJenisStokAsal]
					   ,[idJenisStokTujuan]
					   ,[keterangan]
					   ,[idUserEntry])
				 VALUES
					   (@tanggalRetur
					   ,2/*Retur Kegudang*/
					   ,@idJenisStokAsal
					   ,1/*Gudang Farmasi*/
					   ,@keterangan
					   ,@idUserEntry);

			SELECT SCOPE_IDENTITY() AS idRetur;
		END
	ELSE
		BEGIN
			SELECT @idRetur AS idMutasi;
		END
END