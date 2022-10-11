-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[keuangan_adminKeuangan_masterTarif_listTarif]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idMasterPelayanan, b.idMasterTarif, b.idKelas, b.idMasterTarifHeader, a.namaMasterPelayanan, ba.namaTarifHeader, bb.namaKelas, bc.tarif
		  ,Case	
				When Exists(Select Top 1 1
						      From dbo.transaksiTindakanPasien xa
						     Where xa.idMasterTarif = b.idMasterTarif)
					 Then 0
				Else 1
			End As flagHapus
	  FROM dbo.masterPelayanan a
		   Inner Join dbo.masterTarip b On a.idMasterPelayanan = b.idMasterPelayanan
				Inner Join dbo.masterTarifHeader ba On b.idMasterTarifHeader = ba.idMasterTarifHeader
				Inner Join dbo.masterKelas bb On b.idKelas = bb.idKelas
				Outer Apply (Select Sum(xa.tarip) As tarif
							   From dbo.masterTaripDetail xa
							  Where xa.idMasterTarip = b.idMasterTarif And xa.status = 1) bc
  ORDER BY a.namaMasterPelayanan, ba.namaTarifHeader, b.idKelas
END