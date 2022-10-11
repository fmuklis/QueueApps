-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[casemix_penagihan_klaimBpjs_klaimBillingIgd]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint,
	@noBpjs varchar(50),
	@sep varchar(50),
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @idBilling BIGINT
		   ,@grouping bit = 0;

    -- Insert statements for procedure here

	/*Add Billing Tagihan IGD BPJS*/
	INSERT INTO [dbo].[transaksiBillingHeader]
				([idPendaftaranPasien]
				,[idJenisBilling]
				,[idUserEntry]
				,[idStatusKlaim]
				,[kodeBayar])
		  SELECT a.idPendaftaranPasien
				,5 /*IGD*/
				,@idUserEntry
				,1/*Siap Klaim*/
				,dbo.noKwitansi()
			FROM dbo.transaksiPendaftaranPasien a
				 LEFT JOIN dbo.transaksiBillingHeader b ON a.idPendaftaranPasien = b.idPendaftaranPasien AND b.idJenisBilling = 5 /*IGD*/
		   WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND b.idBilling IS NULL;

	SET @idBilling = SCOPE_IDENTITY();

	/*Update Data Kartu BPJS*/
	UPDATE a
	   SET a.noBPJS = TRIM(@noBpjs)
	  FROM dbo.masterPasien a
		   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPasien = b.idPasien
	 WHERE b.idPendaftaranPasien = @idPendaftaranPasien;

	/*Update Data SEP Pendaftaran*/
	UPDATE dbo.transaksiPendaftaranPasien
	   SET noSEPRawatJalan = TRIM(@sep)
	 WHERE idPendaftaranPasien = @idPendaftaranPasien AND (LEN(noSEPRawatJalan) < 19 OR noSEPRawatJalan IS NULL);

	IF EXISTS(SELECT TOP 1 1 FROM dbo.transaksiTindakanPasien a
					 OUTER APPLY dbo.getInfo_biayaTindakan(a.idTindakanPasien) b
			   WHERE idPendaftaranPasien = @idPendaftaranPasien AND b.idMasterTarifGroup IS NULL)
		BEGIN
			SET @grouping = 1;
		END
	
	SELECT 'Tagihan Perawatan IGD Siap Diklaim' AS respon, 1 AS responCode, @idBilling AS idBilling, @grouping AS [grouping];
END