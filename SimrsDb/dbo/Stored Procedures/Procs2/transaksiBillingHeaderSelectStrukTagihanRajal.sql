-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiBillingHeaderSelectStrukTagihanRajal]
	-- Add the parameters for the stored procedure here
	@idBilling int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from

	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT c.namaTarifHeader As namaTarif, b.tglBayar, b.namaLengkap, b.qty, b.total, b.total / b.qty As tarif
	  FROM dbo.masterTarip a
		   Inner Join (Select xa.idMasterTarif, xb.tglBayar, xd.namaLengkap, Count(xa.idMasterTarif) As qty, Sum(xc.total) As total
						 From dbo.transaksiTindakanPasien xa 
							  Inner Join dbo.transaksiBillingHeader xb On xa.idJenisBilling = xb.idJenisBilling And xa.idPendaftaranPasien = xb.idPendaftaranPasien
							  Inner Join (Select y.idTindakanPasien, Sum(y.nilai) As total
											From dbo.transaksiTindakanPasienDetail y
										Group By y.idTindakanPasien) xc On xa.idTindakanPasien = xc.idTindakanPasien
							  Inner Join dbo.masterUser xd On xb.idUserBayar = xd.idUser
						Where xb.idBilling = @idBilling
					 Group By xa.idMasterTarif, xb.tglBayar, xd.namaLengkap) b On a.idMasterTarif = b.idMasterTarif
		   Inner Join dbo.masterTarifHeader c On a.idMasterTarifHeader = c.idMasterTarifHeader					
  ORDER BY c.namaTarifHeader;
END