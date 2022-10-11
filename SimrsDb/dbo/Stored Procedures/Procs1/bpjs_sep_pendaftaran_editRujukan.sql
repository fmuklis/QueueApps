
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bpjs_sep_pendaftaran_editRujukan]
	-- Add the parameters for the stored procedure here
	@idRujukan bigint,
	@nomorRujukan varchar(50),
	@tglRujukan date,
	@tglKunjungan date,
	@kodeFaskes varchar(50),
	@kodePpkDirujuk varchar(50),
	@ppkDirujuk varchar(50),
	@jnsPelayanan tinyint,
	@catatan varchar(500),
	@kodeDiagnosa varchar(50),
	@diagnosa varchar(50),
	@tipeRujukan tinyint,
	@kodePoli varchar(50),
	@poli varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF NOT EXISTS(SELECT 1 FROM dbo.bpjsMasterPpk WHERE kodePpkRujukan = @kodePpkDirujuk)
		BEGIN
			INSERT INTO [dbo].[bpjsMasterPpk]
					   ([kodePpkRujukan]
					   ,[ppkRujukan])
				 VALUES
					   (@kodePpkDirujuk
					   ,@ppkDirujuk)
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

		UPDATE [dbo].[bpjsRujukan]
		   SET [tanggalRujukan] = @tglRujukan
			  ,[tanggalKunjungan] = @tglKunjungan
			  ,[kodeFaskes] = @kodeFaskes
			  ,[kodePpkDirujuk] = @kodePpkDirujuk
			  ,[jenisPelayanan] = @jnsPelayanan
			  ,[catatan] = @catatan
			  ,[idMasterICD] = (SELECT idMasterICD FROM dbo.masterICD WHERE ICD = @kodeDiagnosa)
			  ,[tipeRujukan] = @tipeRujukan
			  ,[kodePoliRujukan] = @kodePoli
		 WHERE idRujukan = @idRujukan;
END