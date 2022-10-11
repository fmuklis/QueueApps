-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[ugd_perawatUgd_dashboard_batalUgd]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiPendaftaranPasien WHERE idPendaftaranPasien = @idPendaftaranPasien
					 AND idStatusPendaftaran <> 1/*Selesai Pendaftaran*/)
		BEGIN
			Select 'Tidak Dapat Dibatalkan, '+ b.deskripsi As respon, 0 As responCode
			  FROM dbo.transaksiPendaftaranPasien a
				   LEFT JOIN dbo.masterStatusPendaftaran b ON a.idStatusPendaftaran = b.idStatusPendaftaran
			 WHERE a.idPendaftaranPasien = @idPendaftaranPasien;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			/*Delete Data Pendaftaran*/
			DELETE dbo.transaksiPendaftaranPasien
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Pasien Batal Rawat Darurat, Data Pendaftaran Berhasil Dihapus' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END