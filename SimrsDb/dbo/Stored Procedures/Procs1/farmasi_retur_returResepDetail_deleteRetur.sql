-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_returResepDetail_deleteRetur]
	-- Add the parameters for the stored procedure here
	@idRetur bigint,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idJenisStok int = (Select b.idJenisStok From dbo.masterUser a
									   Inner Join dbo.masterRuangan b On a.idRuangan = b.idRuangan
								 Where a.idUser = @idUserEntry);
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiPenjualanDetail a
					 INNER JOIN dbo.farmasiPenjualanHeader b ON a.idPenjualanHeader = b.idPenjualanHeader
					 INNER JOIN dbo.farmasiReturDetail c ON a.idPenjualanDetail = c.idPenjualanDetail
			   WHERE c.idReturDetail = @idRetur AND b.idBilling Is Not Null)
		BEGIN
			SELECT 'Tidak Dapat Diretur, Resep Telah Dibayar Oleh Pasien' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiReturDetail WHERE idReturDetail = @idRetur AND valid = 1)
		BEGIN
			Select 'Tidak Dapat Dihapus, Retur Telah Divalidasi' AS respon, 0 AS responCode;
		END
	ELSE IF NOT EXISTS(SELECT 1 FROM dbo.farmasiPenjualanDetail a
							  INNER JOIN dbo.farmasiMasterObatDetail b ON a.idObatDetail = b.idObatDetail
							  INNER JOIN dbo.farmasiReturDetail c ON a.idPenjualanDetail = c.idPenjualanDetail
						Where c.idReturDetail = @idRetur AND b.idJenisStok = @idJenisStok)
		BEGIN
			Select 'Resep Hanya Bisa Diretur Ke '+ ba.namaJenisStok AS respon, 0 AS responCode
			  From dbo.farmasiPenjualanDetail a
				   INNER JOIN dbo.farmasiMasterObatDetail b ON a.idObatDetail = b.idObatDetail
						INNER JOIN dbo.farmasiMasterObatJenisStok ba ON b.idJenisStok = ba.idJenisStok
				   INNER JOIN dbo.farmasiReturDetail c ON a.idPenjualanDetail = c.idPenjualanDetail
			 Where c.idReturDetail = @idRetur;
		END
	Else
		Begin
			/*DELETE Hapus Data Retur*/
			DELETE dbo.farmasiReturDetail
			 WHERE idReturDetail = @idRetur;

			/*Respon*/
			Select 'Data Retur Berhasil Dihapus' As respon, 1 As responCode;
 		End
END