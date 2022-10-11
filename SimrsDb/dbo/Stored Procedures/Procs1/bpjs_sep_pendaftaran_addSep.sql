
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bpjs_sep_pendaftaran_addSep]
	-- Add the parameters for the stored procedure here
	@idPasien bigint,
	@nomorKartu varchar(50),
	@noTelp varchar(50),
	@tanggalSep date,
	@idJenisPerawatan tinyint,
	@kodeKelasBPJS tinyint,
	@kodeFaskes tinyint,
	@nomorRujukan varchar(50),
	@tanggalRujukan date,
	@kodePpkRujukan varchar(50),
	@ppkRujukan varchar(50),
	@catatan varchar(500),
	@kodeDiagnosa varchar(50),
	@diagnosa varchar(50),
	@kodePoli varchar(50),
	@poli varchar(50),
	@eksekutif bit,
	@cob bit,
	@katarak bit,
	@lakaLantas bit,
	@idJenisLaka tinyint,
	@penjamin varchar(50),
	@tanggalKejadian date,
	@keterangan varchar(500),
	@suplesi bit,
	@sepSuplesi varchar(50),
	@kodePropinsi varchar(50),
	@propinsi varchar(50),
	@kodeKabupaten varchar(50),
	@kabupaten varchar(500),
	@kodeKecamatan varchar(50),
	@kecamatan varchar(50),
	@nomorSurat varchar(50),
	@kodeDpjp varchar(50),
	@dpjp varchar(50),
	@dpjpLayan varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idSep bigint;

	SELECT @idSep = idSep
	  FROM dbo.bpjsSep
	 WHERE idPasien = @idPasien AND nomorSep IS NULL;

	IF LEN(ISNULL(@kodePpkRujukan, 0)) <= 1
		BEGIN
			SET @kodePpkRujukan = NULL;
		END

	IF @kodeFaskes = 0
		BEGIN
			SET @kodeFaskes = NULL;
		END
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @listPenjamin table(penjamin varchar(50));
	INSERT INTO @listPenjamin
			   (penjamin)
		 SELECT value
		   FROM string_split(@penjamin, '#')
		  WHERE value <> '';

	IF NOT EXISTS(SELECT 1 FROM dbo.bpjsMasterPpk WHERE kodePpkRujukan = @kodePpkRujukan) AND @kodePpkRujukan IS NOT NULL
		BEGIN
			INSERT INTO [dbo].[bpjsMasterPpk]
					   ([kodePpkRujukan]
					   ,[ppkRujukan])
				 VALUES
					   (@kodePpkRujukan
					   ,@ppkRujukan)
		END

	IF NOT EXISTS(SELECT 1 FROM dbo.masterICD WHERE ICD = @kodeDiagnosa)
		BEGIN
			INSERT INTO [dbo].[masterICD]
					   ([ICD]
					   ,[diagnosa])
				 VALUES
					   (@kodeDiagnosa
					   ,@diagnosa)
		END

	IF NOT EXISTS(SELECT 1 FROM dbo.bpjsMasterPoli WHERE kodePoli = @kodePoli)
		BEGIN
			INSERT INTO [dbo].[bpjsMasterPoli]
					   ([kodePoli]
					   ,[poli])
				 VALUES
					   (@kodePoli
					   ,@poli)
		END

	IF NOT EXISTS(SELECT 1 FROM dbo.bpjsMasterPropinsi WHERE kodePropinsi = @kodePropinsi)
		BEGIN
			INSERT INTO [dbo].[bpjsMasterPropinsi]
					   ([kodePropinsi]
					   ,[propinsi])
				 VALUES
					   (@kodePropinsi
					   ,@propinsi)
		END

	IF NOT EXISTS(SELECT 1 FROM dbo.bpjsMasterkabupaten WHERE kodeKabupaten = @kodeKabupaten)
		BEGIN
			INSERT INTO [dbo].[bpjsMasterkabupaten]
					   ([kodeKabupaten]
					   ,[kodePropinsi]
					   ,[kabupaten])
				 VALUES
					   (@kodeKabupaten
					   ,@kodePropinsi
					   ,@kabupaten)
		END

	IF NOT EXISTS(SELECT 1 FROM dbo.bpjsMasterKecamatan WHERE kodeKecamatan = @kodeKecamatan)
		BEGIN
			INSERT INTO [dbo].[bpjsMasterKecamatan]
					   ([kodeKecamatan]
					   ,[kodeKabupaten]
					   ,[kecamatan])
				 VALUES
					   (@kodeKecamatan
					   ,@kodeKabupaten
					   ,@kecamatan)
		END

	IF NOT EXISTS(SELECT 1 FROM dbo.bpjsMasterDpjp WHERE kodeDpjp = @kodeDpjp)
		BEGIN
			INSERT INTO [dbo].[bpjsMasterDpjp]
					   ([kodeDpjp]
					   ,[dpjp])
				 VALUES
					   (@kodeDpjp
					   ,@dpjp)
		END
	
	UPDATE dbo.masterPasien
	   SET noBPJS = @nomorKartu
		  ,noHpPasien1 = @noTelp
	 WHERE idPasien = @idPasien;

	IF @idSep IS NULL
		BEGIN
			INSERT INTO [dbo].[bpjsSep]
					   ([idPasien]
					   ,[tanggalSep]
					   ,[idJenisPerawatan]
					   ,[kodeKelasBPJS]
					   ,[kodeFaskes]
					   ,[nomorRujukan]
					   ,[tanggalRujukan]
					   ,[kodePpkRujukan]
					   ,[catatan]
					   ,[idMasterICD]
					   ,[kodePoli]
					   ,[eksekutif]
					   ,[cob]
					   ,[katarak]
					   ,[lakaLantas]
					   ,[idJenisLaka]
					   ,[tanggalKejadian]
					   ,[keterangan]
					   ,[suplesi]
					   ,[sepSuplesi]
					   ,[kodeKecamatan]
					   ,[nomorSurat]
					   ,[kodeDpjp]
					   ,[dpjpLayan])
				 VALUES
					   (@idPasien
					   ,@tanggalSep
					   ,@idJenisPerawatan
					   ,@kodeKelasBPJS
					   ,@kodeFaskes
					   ,@nomorRujukan
					   ,@tanggalRujukan
					   ,@kodePpkRujukan
					   ,@catatan
					   ,(SELECT idMasterICD FROM dbo.masterICD WHERE ICD = @kodeDiagnosa)
					   ,@kodePoli
					   ,@eksekutif
					   ,@cob
					   ,@katarak
					   ,@lakaLantas
					   ,@idJenisLaka
					   ,@tanggalKejadian
					   ,@keterangan
					   ,@suplesi
					   ,@sepSuplesi
					   ,@kodeKecamatan
					   ,@nomorSurat
					   ,@kodeDpjp
					   ,@dpjpLayan);

			SET @idSep = SCOPE_IDENTITY();

			INSERT INTO bpjsSepPenjaminLakalantas
					   (idSep
					   ,kodePenjamin)
				 SELECT @idSep
					   ,penjamin
				   FROM @listPenjamin
				  WHERE LEN(penjamin) >= 1

			SELECT 'Data SEP Berhasil Disimpan' AS respon, 1 AS responCode, @idSep AS idSep;
		END
	ELSE
		BEGIN
			UPDATE [dbo].[bpjsSep]
			   SET [tanggalSep] = @tanggalSep
				  ,[idJenisPerawatan] = @idJenisPerawatan
				  ,[kodeKelasBPJS] = @kodeKelasBPJS
				  ,[kodeFaskes] = @kodeFaskes
				  ,[nomorRujukan] = @nomorRujukan
				  ,[tanggalRujukan] = @tanggalRujukan
				  ,[kodePpkRujukan] = @kodePpkRujukan
				  ,[catatan] = @catatan
				  ,[idMasterICD] = (SELECT idMasterICD FROM dbo.masterICD WHERE ICD = @kodeDiagnosa)
				  ,[kodePoli] = @kodePoli
				  ,[eksekutif] = @eksekutif
				  ,[cob] = @cob
				  ,[katarak] = @katarak
				  ,[lakaLantas] = @lakaLantas
				  ,[idJenisLaka] = @idJenisLaka
				  ,[tanggalKejadian] = @tanggalKejadian
				  ,[keterangan] = @keterangan
				  ,[suplesi] = @suplesi
				  ,[sepSuplesi] = @sepSuplesi
				  ,[kodeKecamatan] = @kodeKecamatan
				  ,[nomorSurat] = @nomorSurat
				  ,[kodeDpjp] = @kodeDpjp
				  ,[dpjpLayan] = @dpjpLayan
			 WHERE idSep = @idSep;

			INSERT INTO bpjsSepPenjaminLakalantas
					   (idSep
					   ,kodePenjamin)
				 SELECT @idSep
					   ,penjamin
				   FROM @listPenjamin a
					    LEFT JOIN dbo.bpjsSepPenjaminLakalantas b ON a.penjamin = b.kodePenjamin AND b.idSep = @idSep
				  WHERE LEN(penjamin) >= 1 AND b.idSepPenjaminLakalantas IS NULL;

			DELETE a
			  FROM dbo.bpjsSepPenjaminLakalantas a
				   LEFT JOIN @listPenjamin b ON a.kodePenjamin = b.penjamin
			 WHERE a.idSep = @idSep AND b.penjamin IS NULL;

			SELECT 'Data SEP Berhasil Diupdate' AS respon, 1 AS responCode, @idSep AS idSep;
		END
END