-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingIgd_listBhpTindakan]
	-- Add the parameters for the stored procedure here
	@idTindakanPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPenjualanDetail, @idTindakanPasien AS idTindakanPasien, a.namaBHP, a.jmlBHP, a.tarifBHP, a.jmlTarifBHP
	  FROM dbo.getInfo_bhpTindakan(@idTindakanPasien) a;
END