-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterTaripSelectByIDMasterPelayanan]
	-- Add the parameters for the stored procedure here
	@IdMasterPelayanan int,
	@idRuangan int,
	@idPendaftaranPasien int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	/*DECLARE @IdKelas int = (Select Case
										When (Select idOrderRawatInap From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien) = 4
											Then (Select idKelas From masterRuanganRawatInap Where idRuanganRawatInap = (Select b.idRuanganRawatInap From transaksiPendaftaranPasien a
																																	 Inner Join masterRuanganTempatTidur b On a.idTempatTidur = b.idTempatTidur
																														  Where idPendaftaranPasien = @idPendaftaranPasien))
										Else (Select idKelas From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien)
									End)*/

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idMasterTarif ,c.namaTarifHeader As namaTarif,a.Keterangan
		   ,b.idRuangan 
	  FROM dbo.masterTarip a
		   Inner Join dbo.masterRuanganPelayanan b On a.idMasterPelayanan = b.idMasterPelayanan
		   Inner Join dbo.masterTarifHeader c On a.idMasterTarifHeader = c.idMasterTarifHeader		
	 WHERE a.idMasterPelayanan = @IdMasterPelayanan And a.idKelas = 99/*Non Kelas*/ And b.idRuangan = @idRuangan
  ORDER BY c.namaTarifHeader
END