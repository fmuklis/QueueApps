-- =============================================
-- Author:		<Author,,Name>
-- CREATE date: <CREATE Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[casemix_penagihan_klaimBpjs_updateKlaimRanap]
	-- Add the parameters for the stored procedure here
	@idBilling bigint,
	@rawatIntensif bit,
	@pemakaianVentilator smallint,
	@lamaRawatIntensif smallint,
	@lamaRawatInap smallint,
	@tarifProsedurNonBedah money,
	@tarifProsedurBedah money,
	@tarifKonsultasi money,
	@tarifTenagaAhli money,
	@tarifKeperawatan money,
	@tarifPenunjang money,
	@tarifRadiologi money,
	@tarifLaboratorium money,
	@tarifPelayananDarah money,
	@tarifRehabilitasi money,
	@tarifKamarAkomodasi money,
	@tarifRawatIntensif money,
	@tarifObat money,
	@tarifObatKronis money,
	@tarifObatKemoterapi money,
	@tarifAlkes money,
	@tarifBMHP money,
	@tarifSewaAlat money,
	@ICD nvarchar(50),
	@diagnosa nvarchar(max),
	@listDiagSekunder nvarchar(max),
	@listProsedur nvarchar(max),
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @dateNow date = GETDATE();
	DECLARE @idPendaftaran bigint = (SELECT idPendaftaranPasien FROM dbo.transaksiBillingHeader WHERE idBilling = @idBilling);
	Declare @tableDiagnosa table(primer bit, ICD nvarchar(50), diagnosa nvarchar(max));

	INSERT INTO @tableDiagnosa
			   ([primer]
			   ,[ICD]
			   ,[diagnosa])
		 VALUES 
			   (1
			   ,@ICD
			   ,@diagnosa);

	INSERT INTO @tableDiagnosa
			   ([primer]
			   ,[ICD]
			   ,[diagnosa])
		 SELECT 0, b.[1], b.[2]
		   FROM STRING_SPLIT(@listDiagSekunder, '|') a
				OUTER APPLY dbo.generate_stringTable(a.value) b
		  WHERE LEN(ISNULL(b.[1], '')) > 1;

	Declare @tableProsedur table(kodeProsedur nvarchar(50), prosedur nvarchar(max));

	INSERT INTO @tableProsedur
			   ([kodeProsedur]
			   ,[prosedur])
		 SELECT Cast(Left(value, CharIndex('|', value)-1) As nvarchar(50))
			   ,Cast(Right(value, CharIndex('|', reverse(value))-1) As nvarchar(max))
		   FROM STRING_SPLIT(@listProsedur, CHAR(9)) a
		  WHERE Trim(value) <> '';
    -- Insert statements for procedure here

	Begin Try
		/*Transaction Begin*/
		Begin Tran;

		/*INSERT Master Data ICD & Prosedur*/
		INSERT INTO [dbo].[masterICD]
				   ([ICD]
				   ,[diagnosa])
			 SELECT a.ICD
				   ,a.diagnosa
			   FROM @tableDiagnosa a
					LEFT JOIN dbo.masterICD b On a.ICD = b.ICD
			  WHERE b.idMasterICD Is Null;

		INSERT INTO [dbo].[masterICDProsedur]
				   ([kodeProsedur]
				   ,[prosedur])
			 SELECT a.kodeProsedur
				   ,a.prosedur
			   FROM @tableProsedur a
					LEFT JOIN dbo.masterICDProsedur b On a.kodeProsedur = b.kodeProsedur
			  WHERE b.idMasterProsedur Is Null;

		/*DELETE List Klaim Diagnosa & Prosedur*/
		DELETE dbo.transaksiBillingDiagnosa
		 WHERE idBilling = @idBilling;

		DELETE dbo.transaksiBillingProsedur
		 WHERE idBilling = @idBilling;

		/*INSERT List Klaim Diagnosa & Prosedur*/
		INSERT INTO [dbo].[transaksiBillingDiagnosa]
				   ([idBilling]
				   ,[idMasterICD]
				   ,[primer])
			 SELECT @idBilling
				   ,b.idMasterICD
				   ,a.primer
			   FROM @tableDiagnosa a
					INNER JOIN dbo.masterICD b On a.ICD = b.ICD;

		INSERT INTO [dbo].[transaksiBillingProsedur]
				   ([idBilling]
				   ,[idMasterProsedur])
			 SELECT @idBilling
				   ,b.idMasterProsedur
			   FROM @tableProsedur a
					INNER JOIN dbo.masterICDProsedur b On a.kodeProsedur = b.kodeProsedur;

		UPDATE [dbo].[transaksiBillingHeader]
		   SET [rawatIntensif] = @rawatIntensif
			  ,[pemakaianVentilator] = @pemakaianVentilator
			  ,[lamaRawatIntensif] = @lamaRawatIntensif
			  ,[lamaRawatInap] = @lamaRawatInap
			  ,[tarifProsedurNonBedah] = @tarifProsedurNonBedah
			  ,[tarifProsedurBedah] = @tarifProsedurBedah
			  ,[tarifKonsultasi] = @tarifKonsultasi
			  ,[tarifTenagaAhli] = @tarifTenagaAhli
			  ,[tarifKeperawatan] = @tarifKeperawatan
			  ,[tarifPenunjang] = @tarifPenunjang
			  ,[tarifRadiologi] = @tarifRadiologi
			  ,[tarifLaboratorium] = @tarifLaboratorium
			  ,[tarifPelayananDarah] = @tarifPelayananDarah
			  ,[tarifRehabilitasi] = @tarifRehabilitasi
			  ,[tarifKamarAkomodasi] = @tarifKamarAkomodasi
			  ,[tarifRawatIntensif] = @tarifRawatIntensif
			  ,[tarifObat] = @tarifObat
			  ,[tarifObatKronis] = @tarifObatKronis
			  ,[tarifObatKemoterapi] = @tarifObatKemoterapi
			  ,[tarifAlkes] = @tarifAlkes
			  ,[tarifBMHP] = @tarifBMHP
			  ,[tarifSewaAlat] = @tarifSewaAlat
			  ,[idStatusKlaim] = 3/*Klaim Disimpan*/
		 WHERE idBilling = @idBilling;

		/*Transaction Commit*/
		Commit Tran;

		/*Respon*/
		Select 'Data Klaim Berhasil Diupdate' As respon, 1 As responCode;
	End Try
	Begin Catch
		/*Transaction Rollback*/
		Rollback Tran;

		Select 'Error!: '+ ERROR_MESSAGE() As respon, NULL As responCode;
	End Catch
END