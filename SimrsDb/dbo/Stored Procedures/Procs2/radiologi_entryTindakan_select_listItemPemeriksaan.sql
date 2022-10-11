-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[radiologi_entryTindakan_select_listItemPemeriksaan]
	-- Add the parameters for the stored procedure here
	@idOrder bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.idOrderDetail, ba.namaTarif
		  ,Case
				When bb.idTindakanPasien Is Null
					 Then 1
				Else 0
			End As btnPilih
	  FROM dbo.transaksiOrder a
		   Inner Join dbo.transaksiOrderDetail b On a.idOrder = b.idOrder
				Outer Apply dbo.getinfo_tarif(b.idMasterTarif) ba
				Left Join dbo.transaksiTindakanPasien bb On b.idOrderDetail = bb.idOrderDetail
	 WHERE a.idOrder = @idOrder;
END