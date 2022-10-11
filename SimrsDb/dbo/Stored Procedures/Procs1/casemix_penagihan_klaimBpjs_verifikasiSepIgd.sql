-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[casemix_penagihan_klaimBpjs_verifikasiSepIgd]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	SELECT a.noSEPRawatJalan AS SEP, b.noBPJS
	  FROM dbo.transaksiPendaftaranPasien a
		   INNER JOIN dbo.masterPasien b ON a.idPasien = b.idPasien
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien;
END