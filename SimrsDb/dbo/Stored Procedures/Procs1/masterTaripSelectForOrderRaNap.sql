﻿-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterTaripSelectForOrderRaNap]
	-- Add the parameters for the stored procedure here
	@idRuangan int,
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
/*	Declare @IdKelas int = Case
								When @idRuangan = 21 
									 And Exists(Select b.idKelas From dbo.transaksiPendaftaranPasien a
													   Inner Join dbo.transaksiPendaftaranPasienDetail b On a.idPendaftaranPasien = b.idPendaftaranPasien And b.flagAktif = 1
												 Where a.idPendaftaranPasien = @idPendaftaranPasien)
									 Then 5
								Else 99
							End
*/
	SET NOCOUNT ON;

    -- Insert statements for procedure here
/*	SELECT a.idMasterTarif ,c.namaTarifHeader As namaTarif,a.Keterangan
		   ,b.idRuangan 
	  FROM dbo.masterTarip a
		   Inner Join dbo.masterRuanganPelayanan b On a.idMasterPelayanan = b.idMasterPelayanan
		   Inner Join dbo.masterTarifHeader c On a.idMasterTarifHeader = c.idMasterTarifHeader		
	 WHERE b.idRuangan = @idRuangan And a.idKelas = @IdKelas
  ORDER BY c.namaTarifHeader*/
END