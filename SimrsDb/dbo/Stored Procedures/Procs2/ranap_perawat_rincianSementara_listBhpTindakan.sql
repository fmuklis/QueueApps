-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ranap_perawat_rincianSementara_listBhpTindakan]
	-- Add the parameters for the stored procedure here
	@idTindakanPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPenjualanDetail, @idTindakanPasien AS idTindakanPasien, a.namaBHP
		  ,a.tarifBHP, a.jmlBHP, a.jmlTarifBHP, a.keterangan
	  FROM dbo.getInfo_bhpTindakan(@idTindakanPasien) a;
END