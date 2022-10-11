-- =============================================
-- Author:	Start-X
-- Create date: 15-10-2021 (modified)
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[casemix_penagihan_klaimBpjs_stageDuaRajal]
	-- Add the parameters for the stored procedure here
	@idBilling bigint,
	@spesialCMG varchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*Make variable*/
	DECLARE @tableCMG table(kode varchar(50), tarif money, typeCMG varchar(50));

	/*Collect parameter value*/
	INSERT INTO @tableCMG
			   (kode
			   ,tarif
			   ,typeCMG)
		 SELECT b.[1]
			   ,b.[2]
			   ,b.[3]
		   FROM string_split(@spesialCMG, '|') a
				OUTER APPLY dbo.generate_stringTable(a.value) b
		  WHERE b.[1] IS NOT NULL;

	/*UPDATE data spesialis CMG*/
	UPDATE a
	   SET a.kode = bb.kode
		  ,a.tarif = bb.tarif
	  FROM dbo.transaksiBillingCMG a
		   INNER JOIN dbo.masterCMG b ON a.idMasterCMG = b.idMasterCMG
				INNER JOIN dbo.masterCMGType ba ON b.idMasterCMGType = ba.idMasterCMGType
				LEFT JOIN @tableCMG bb ON ba.CMGType = bb.typeCMG
	 WHERE a.idBilling = @idBilling;

	/*UPDATE Status Billing*/
	UPDATE dbo.transaksiBillingHeader
	   SET idStatusKlaim = 5/*Grouping Stage 2*/
	 WHERE idBilling = @idBilling;

	Select 'Status Billing Berhasil Diupdate '+ b.statusKlaim As respon, 1 As responCode
	  From dbo.transaksiBillingHeader a
		   Inner Join dbo.masterStatusKlaim b On a.idStatusKlaim = b.idStatusKlaim
	 Where a.idBilling = @idBilling;
END