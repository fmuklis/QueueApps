-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_mutasi_requestMutasi_addRequest]
	-- Add the parameters for the stored procedure here
	@idJenisStokAsal int,
	@tglMutasi date,
	@keterangan varchar(max),
	@idUserEntry int
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStokTujuan tinyint = (SELECT idJenisStok FROM dbo.masterRuangan a
												 INNER JOIN dbo.masterUser b ON a.idRuangan = b.idRuangan
										   WHERE b.idUser = @idUserEntry);
	DECLARE @idMutasi int;

	 SELECT @idMutasi = idMutasi 
	   FROM dbo.farmasiMutasi a
	  WHERE idJenisMutasi = 1/*Mutasi Barang Farmasi*/ AND a.idJenisStokAsal = @idJenisStokAsal
			AND a.idJenisStokTujuan = @idJenisStokTujuan AND tanggalOrder = @tglMutasi AND idStatusMutasi = 1/*Permintaan Mutasi*/;
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF @idMutasi IS NULL
		BEGIN
			INSERT INTO [dbo].[farmasiMutasi]
					   ([idJenisStokAsal]
					   ,[idJenisStokTujuan]
					   ,[nomorOrder]
					   ,[idUserEntry]
					   ,[tanggalOrder]
					   ,[keterangan])
				 VALUES
					   (@idJenisStokAsal
					   ,@idJenisStokTujuan
					   ,dbo.generate_nomorRequestMutasi(@tglMutasi)
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