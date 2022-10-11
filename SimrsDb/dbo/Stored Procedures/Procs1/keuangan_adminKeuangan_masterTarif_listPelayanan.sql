-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[keuangan_adminKeuangan_masterTarif_listPelayanan]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idMasterPelayanan, a.namaMasterPelayanan
		  ,Case	
				When Exists(Select Top 1 1
							  From dbo.masterTarip xa
								   Inner Join dbo.transaksiTindakanPasien xb On xa.idMasterTarif = xb.idMasterTarif
							 Where xa.idMasterPelayanan = a.idMasterPelayanan)
					 Then 0
				Else 1
			End As flagHapus
	  FROM dbo.masterPelayanan a
  ORDER BY a.namaMasterPelayanan
END