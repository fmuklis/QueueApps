-- =============================================
-- Author	  :	Start-X
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ranap_perawat_entryTindakan_listRiwayatDiagnosa]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*Execute procedure*/
	EXECUTE dbo.spPasien_GetRiwayatDiagnosa @idPendaftaranPasien;

END