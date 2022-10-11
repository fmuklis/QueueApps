-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
create PROCEDURE [dbo].[rajal_perawatPoli_entryTindakan_listTarip]
	-- Add the parameters for the stored procedure here
	@idRuangan int,
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @IdKelas int = Case
								When @idRuangan = 21 
									 And Exists(Select 1 From dbo.transaksiPendaftaranPasien a
													   Inner Join dbo.masterJenisPenjaminPembayaranPasien b On a.idJenisPenjaminPembayaranPasien = b.idJenisPenjaminPembayaranPasien
												 Where idPendaftaranPasien = @idPendaftaranPasien And b.idJenisPenjaminPembayaranPasien = 3)
									 Then 5
								When @idRuangan = 21
									 And Exists(Select 1 From dbo.transaksiPendaftaranPasien a
													   Inner Join dbo.masterJenisPenjaminPembayaranPasien b On a.idJenisPenjaminPembayaranPasien = b.idJenisPenjaminPembayaranPasien
												 Where idPendaftaranPasien = @idPendaftaranPasien And b.idJenisPenjaminPembayaranPasien <> 3)
									 Then 4
								Else 99
							End

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idMasterTarif ,c.namaTarifHeader As namaTarif,a.Keterangan
		   ,b.idRuangan 
	  FROM dbo.masterTarip a
		   Inner Join dbo.masterRuanganPelayanan b On a.idMasterPelayanan = b.idMasterPelayanan
		   Inner Join dbo.masterTarifHeader c On a.idMasterTarifHeader = c.idMasterTarifHeader		
	 WHERE b.idRuangan = @idRuangan And a.idKelas = @IdKelas
  ORDER BY c.namaTarifHeader
END