-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[radiologi_pemeriksaan_entryTindakan_select_diagnosaPasien]
	-- Add the parameters for the stored procedure here
	@idOrder bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ba.ICD +' - '+ ba.diagnosa As diagnosa
	  FROM dbo.transaksiOrder a
		   Inner Join dbo.transaksiDiagnosaPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
				Inner Join dbo.masterICD ba On b.idMasterICD = ba.idMasterICD
	 WHERE a.idOrder = @idOrder
  ORDER BY b.primer DESC;
END