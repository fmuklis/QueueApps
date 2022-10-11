-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[casemix_master_groupTarif_editPemeriksaan]
	-- Add the parameters for the stored procedure here
	@idMasterTarifHeader int,
	@idMasterTarifGroup smallint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE dbo.masterTarifHeader
	   SET idMasterTarifGroup = @idMasterTarifGroup
	 WHERE idMasterTarifHeader = @idMasterTarifHeader;

	SELECT 'Data Kelompok Biaya Pemeriksaan / Pelayanan Berhasil Diupdate' AS respon, 1 AS responCode;
END