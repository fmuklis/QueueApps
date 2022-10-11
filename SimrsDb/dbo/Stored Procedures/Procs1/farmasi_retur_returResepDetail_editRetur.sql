-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_returResepDetail_editRetur]
	-- Add the parameters for the stored procedure here
	@idRetur bigint,
	@jumlahRetur decimal(18,2),
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
	If Exists(Select 1 From dbo.farmasiPenjualanDetail a
					 Inner Join dbo.farmasiPenjualanHeader b On a.idPenjualanHeader = b.idPenjualanHeader
					 Inner Join dbo.farmasiReturDetail c On a.idPenjualanDetail = c.idPenjualanDetail
			   Where c.idReturDetail = @idRetur And b.idBilling Is Not Null)
		Begin
			Select 'Tidak Dapat Diretur, Resep Telah Dibayar Oleh Pasien' As respon, 0 As responCode;
		End
	Else If Not Exists(Select 1 From dbo.farmasiPenjualanDetail a
							  Inner Join dbo.farmasiMasterObatDetail b On a.idObatDetail = b.idObatDetail
							  Inner Join dbo.farmasiReturDetail c On a.idPenjualanDetail = c.idPenjualanDetail
						Where c.idReturDetail = @idRetur And b.idJenisStok = @idJenisStok)
		Begin
			Select 'Obat Ini Hanya Bisa Diretur Ke '+ ba.namaJenisStok As respon, 0 As responCode
			  From dbo.farmasiPenjualanDetail a
				   Inner Join dbo.farmasiMasterObatDetail b On a.idObatDetail = b.idObatDetail
						Inner Join dbo.farmasiMasterObatJenisStok ba On b.idJenisStok = ba.idJenisStok
				   Inner Join dbo.farmasiReturDetail c On a.idPenjualanDetail = c.idPenjualanDetail
			 Where c.idReturDetail = @idRetur;
		End
	Else
		Begin
			/*UPDATE Edit Data Retur*/
			UPDATE dbo.farmasiReturDetail
			   SET jumlahRetur = @jumlahRetur
			 WHERE idReturDetail = @idRetur;

			/*Respon*/
			Select 'Data Retur Berhasil Diupdate' As respon, 1 As responCode;
 		End
END