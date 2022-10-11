-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_diagnosa_entryDiagnosaAkhir_addDiagnosa]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int
	,@listIdDiagnosa varchar(555)
	,@tglDiagnosa date
	,@idDokter int
	,@idUserEntry int
	,@idRuangan int
	,@primer varchar(50)
	,@idJenisPelayanan tinyint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare	@idPasien int = (Select idPasien From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien);
		   
	SET NOCOUNT ON;

	DECLARE @listDiagnosa TABLE(kodeICD VARCHAR(50) NOT NULL, diagnosa VARCHAR(100) NOT NULL);

	INSERT @listDiagnosa (kodeICD, diagnosa) 
		SELECT CAST(LEFT(value, CharIndex('|', VALUE) -1) AS VARCHAR(50)),
				CAST(RIGHT(value, CharIndex('|', reverse(VALUE)) -1) AS VARCHAR(100))
		FROM STRING_SPLIT(@listIdDiagnosa, '#') a
		WHERE VALUE <> '';

    -- Insert statements for procedure here

	IF NOT EXISTS(SELECT TOP 1 1 FROM @listDiagnosa)
		BEGIN
			SELECT 'Tidak Ada Diagnosa Yang Disimpan' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			-- Tambah Data Diagnosa jika belum ada di tabel masterICD
			INSERT INTO [dbo].[masterICD]
						([ICD]
						,[diagnosa])
					SELECT a.kodeICD
							,a.diagnosa
					FROM @listDiagnosa a
						LEFT JOIN dbo.masterICD b ON a.kodeICD = b.ICD
					WHERE b.idMasterICD IS NULL
			If Exists(SELECT TOP 1 1 FROM dbo.transaksiDiagnosaPasien a
							INNER JOIN dbo.masterICD b ON a.idMasterICD = b.idMasterICD
						WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND b.ICD = @primer)
				BEGIN
					UPDATE a 
						SET [primer] = 0
						FROM dbo.transaksiDiagnosaPasien a
							LEFT JOIN dbo.masterICD b ON a.idMasterICD = b.idMasterICD
						WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND b.ICD = @primer;
				END
			ELSE
				BEGIN
					UPDATE dbo.transaksiDiagnosaPasien 
						SET [primer] = 0
					WHERE idPendaftaranPasien = @idPendaftaranPasien;
				END

		INSERT INTO [dbo].[transaksiDiagnosaPasien]
				([idPendaftaranPasien]
				,[idMasterICD]
				,[idDokter]
				,[tglDiagnosa]
				,[tglEntry]
				,[idRuangan]
				,[idUserEntry]
				,[primer]
				,[baru])
			SELECT @idPendaftaranPasien
				,b.idMasterICD
				,@idDokter
				,@tglDiagnosa
				,GETDATE()
				,@idRuangan
				,@idUserEntry
				,CASE
					WHEN a.kodeICD = @primer
						THEN 1
					ELSE 0
				END
				,CASE
					WHEN EXISTS(SELECT TOP 1 1 FROM @listDiagnosa a
									INNER JOIN dbo.masterICD b ON a.kodeICD = b.ICD
									LEFT JOIN dbo.transaksiDiagnosaPasien c ON b.idMasterICD = c.idMasterICD
									INNER JOIN dbo.transaksiPendaftaranPasien d ON c.idPendaftaranPasien = d.idPendaftaranPasien
								WHERE d.idPendaftaranPasien <> @idPendaftaranPasien AND d.idPasien = @idPasien)
						THEN 0
					ELSE 1
				END
		FROM @listDiagnosa a
			INNER JOIN dbo.masterICD b ON a.kodeICD = b.ICD
			LEFT JOIN dbo.transaksiDiagnosaPasien c ON b.idMasterICD = c.idMasterICD AND c.idPendaftaranPasien = @idPendaftaranPasien
		WHERE c.idDiagnosa IS NULL
			   
		-- update data pelayanan
		UPDATE [dbo].[transaksiPendaftaranPasien]
			SET [idPelayananIGD] = @idJenisPelayanan
			WHERE idPendaftaranPasien = @idPendaftaranPasien

		Select 'Diagnosa Berhasil Disimpan' As respon, 1 As responCode;
	End
END