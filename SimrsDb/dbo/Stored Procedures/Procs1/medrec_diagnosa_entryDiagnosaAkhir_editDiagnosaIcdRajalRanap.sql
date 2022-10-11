-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
create PROCEDURE [dbo].[medrec_diagnosa_entryDiagnosaAkhir_editDiagnosaIcdRajalRanap]
	-- Add the parameters for the stored procedure here
	@idDiagnosa int
	,@kodeICD varchar(50)
	,@diagnosa varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idMasterICD INT = (SELECT idMasterICD FROM dbo.masterICD WHERE ICD = @kodeICD)
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF @idMasterICD IS NULL
		BEGIN
			INSERT INTO [dbo].[masterICD]
					   ([ICD]
					   ,[diagnosa])
				 VALUES
					   (@kodeICD
					   ,@diagnosa);
			SET @idMasterICD = SCOPE_IDENTITY();
		END
	ELSE 
		BEGIN
			UPDATE [dbo].[transaksiDiagnosaPasien]
			   SET [idMasterICD] = @idMasterICD
			 WHERE idDiagnosa = @idDiagnosa
			Select 'Diagnosa Berhasil Disimpan' As respon, 1 As responCode;
		END
END