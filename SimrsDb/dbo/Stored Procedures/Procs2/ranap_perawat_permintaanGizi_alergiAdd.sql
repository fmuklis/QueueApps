-- =============================================
-- Author:		komar
-- Create date: 22/11/2021
-- Description:	list alergi per pasien
-- =============================================
CREATE PROCEDURE ranap_perawat_permintaanGizi_alergiAdd 
	-- Add the parameters for the stored procedure here
	@userIdSession int,
	@idPendaftaranPasien int,
	@alergiPasien varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @idPasien int = (SELECT a.idPasien FROM dbo.transaksiPendaftaranPasien a WHERE a.idPendaftaranPasien = @idPendaftaranPasien)

	IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.masterPasienAlergi a WHERE a.idPasien = @idPasien AND a.alergiPasien = @alergiPasien)
		BEGIN
			-- Insert statements for procedure here
			INSERT INTO [dbo].[masterPasienAlergi]
				   ([idPasien]
				   ,[idJenisAlergi]
				   ,[alergiPasien]
				   ,[idUserEntry]
				   ,[tanggalEntry])
			 VALUES
				   (@idPasien
				   ,2
				   ,@alergiPasien
				   ,@userIdSession
				   ,getDate());
				   
			SELECT 1 AS responCode, 'Data berhasil disimpan.' AS respon;
		END
	ELSE 
		BEGIN
			SELECT 1 AS responCode, 'Data sudah ada.' AS respon;
		END

END