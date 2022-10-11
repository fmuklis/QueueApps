-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
create PROCEDURE [dbo].[medrec_diagnosa_entryDiagnosaAkhir_validasiDiagnosa]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT TOP 1 1 FROM dbo.transaksiDiagnosaPasien a 
				LEFT JOIN dbo.masterICD b ON a.idMasterICD = b.idMasterICD
			  WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND a.idMasterICD IS NULL)
		BEGIN
			SELECT 'Tidak Dapat Divalidasi, Masih Item Diagnosa Yang Kosong' AS respon, 0 AS responCode;
		END
	ELSE 
		BEGIN
			UPDATE [dbo].[transaksiPendaftaranPasien]
			SET [idStatusPendaftaran] = 100
			WHERE idPendaftaranPasien = @idPendaftaranPasien
			
			Select 'Berhasil Divalidasi' As respon, 1 As responCode;
		END
END