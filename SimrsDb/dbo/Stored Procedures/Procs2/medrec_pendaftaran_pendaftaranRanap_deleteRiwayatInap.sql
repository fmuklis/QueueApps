-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_deleteRiwayatInap]
	-- Add the parameters for the stored procedure here
	
	@idPendaftaranPasien int,
	@idPendaftaranPasienDetail int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @idStatusPendaftaran int = (
										 SELECT a.idStatusPendaftaran FROM dbo.transaksiPendaftaranPasien a
											WHERE a.idPendaftaranPasien = @idPendaftaranPasien
										);	
	
		IF(@idStatusPendaftaran>=98)
			BEGIN 
				 SELECT 'Data gagal di update, Pasien telah pulang' AS respon, 0 AS responCode;
			END
		ELSE
		BEGIN
			DELETE FROM dbo.transaksiPendaftaranPasienDetail WHERE idPendaftaranPasienDetail = @idPendaftaranPasienDetail; 

			SELECT 'Data berhasil di delete' AS respon, 1 AS responCode;
		END
	
	
			

END