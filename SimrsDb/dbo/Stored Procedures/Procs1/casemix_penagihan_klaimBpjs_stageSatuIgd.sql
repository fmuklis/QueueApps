-- =============================================
-- Author:	Start-X
-- Create date: 15-10-2021 (modified)
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[casemix_penagihan_klaimBpjs_stageSatuIgd]
	-- Add the parameters for the stored procedure here
	@idBilling bigint,
	@cbgKode varchar(50),
	@cbgDescription varchar(250),
	@cbgTarif money,
	@subAcuteKode varchar(50),
	@subAcuteDescription varchar(250),
	@subAcuteTarif money,
	@chronicKode varchar(50),
	@chronicDescription varchar(250),
	@chronicTarif money,
	@spesialCMG varchar(500)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

	/*Make variable*/
	DECLARE @tableCMG table(kode varchar(50), deskripsi varchar(250), typeCMG varchar(50));

	/*Collect parameter value*/
	INSERT INTO @tableCMG
			   (kode
			   ,deskripsi
			   ,typeCMG)
	     SELECT [1]
			   ,[2]
			   ,[3]
	       FROM string_split(@spesialCMG, '|') a
				OUTER APPLY dbo.generate_stringTable(a.value) b
		  WHERE b.[1] IS NOT NULL;

	/*INSERT Data CMG*/
	INSERT INTO dbo.masterCMG
			   ([kodeCMG]
			   ,[description]
			   ,[idMasterCMGType])
	     SELECT a.kode
			   ,a.deskripsi	
			   ,c.idMasterCMGType
		   FROM @tableCMG a
				LEFT JOIN dbo.masterCMG b ON a.kode = b.kodeCMG
				LEFT JOIN dbo.masterCMGType c ON a.typeCMG = c.CMGType
		  WHERE b.idMasterCMGType Is Null And a.kode Is Not Null And a.deskripsi Is Not Null;

	/*UPDATE data tarif grouping*/
	UPDATE dbo.transaksiBillingHeader
	   SET idStatusKlaim = 4/*Grouping Stage 1*/
		  ,cbgKode = @cbgKode
		  ,cbgDescription = @cbgDescription
		  ,cbgTarif = @cbgTarif
		  ,subAcuteKode = @subAcuteKode
		  ,subAcuteDescription = @subAcuteDescription
		  ,subAcuteTarif = @subAcuteTarif
		  ,chronicKode = @chronicKode
		  ,chronicDescription = @chronicDescription
		  ,chronicTarif = @chronicTarif
	 WHERE idBilling = @idBilling;

	/*Entry Data Spesial CMG begin*/
		UPDATE dbo.transaksiBillingCMG
		   SET kode = NULL
			  ,tarif = NULL
		 WHERE idBilling = @idBilling;

		INSERT INTO dbo.transaksiBillingCMG
				   (idBilling
				   ,idMasterCMG)
			 SELECT @idBilling
				   ,b.idMasterCMG
			   FROM @tableCMG a
					INNER JOIN dbo.masterCMG b ON a.kode = b.kodeCMG
						LEFT JOIN dbo.transaksiBillingCMG ba ON b.idMasterCMG = ba.idMasterCMG AND ba.idBilling = @idBilling
			  WHERE ba.idTransaksiBillingCMG IS NULL;

		DELETE a
		  FROM dbo.transaksiBillingCMG a
			   INNER JOIN dbo.masterCMG b ON a.idMasterCMG = b.idMasterCMG
					LEFT JOIN @tableCMG ba ON b.kodeCMG = ba.kode
		 WHERE a.idBilling = @idBilling AND ba.kode IS NULL;
	/*Entry Data Spesial CMG end*/

	Select 'Status Billing Berhasil Diupdate '+ b.statusKlaim As respon, 1 As responCode
	  From dbo.transaksiBillingHeader a
		   Inner Join dbo.masterStatusKlaim b On a.idStatusKlaim = b.idStatusKlaim
	 Where a.idBilling = @idBilling;
END