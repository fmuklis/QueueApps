-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_returResepDetail_addRetur]
	-- Add the parameters for the stored procedure here
	@idPenjualanDetail bigint,
	@jumlahRetur decimal(18,2),
	@tglRetur date,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStok int = (Select b.idJenisStok From dbo.masterUser a
									   Inner Join dbo.masterRuangan b On a.idRuangan = b.idRuangan
								 Where a.idUser = @idUserEntry);
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.farmasiPenjualanDetail a
					 Inner Join dbo.farmasiPenjualanHeader b On a.idPenjualanHeader = b.idPenjualanHeader
			   Where a.idPenjualanDetail = @idPenjualanDetail And b.idBilling Is Not Null)
		Begin
			Select 'Tidak Dapat Diretur, Resep Telah Dibayar Oleh Pasien' As respon, 0 As responCode;
		End
	Else If Not Exists(Select 1 From dbo.farmasiPenjualanDetail a
							  Inner Join dbo.farmasiMasterObatDetail b On a.idObatDetail = b.idObatDetail
						Where a.idPenjualanDetail = @idPenjualanDetail And b.idJenisStok = @idJenisStok)
		Begin
			Select 'Obat Ini Hanya Bisa Diretur Ke '+ ba.namaJenisStok As respon, 0 As responCode
			  From dbo.farmasiPenjualanDetail a
				   Inner Join dbo.farmasiMasterObatDetail b On a.idObatDetail = b.idObatDetail
						Inner Join dbo.farmasiMasterObatJenisStok ba On b.idJenisStok = ba.idJenisStok
			 Where a.idPenjualanDetail = @idPenjualanDetail;
		End
	Else
		Begin
			/*INSERT Entry Data Retur*/
			INSERT INTO [dbo].[farmasiReturDetail]
					   ([idPenjualanDetail]
					   ,[jumlahAsal]
					   ,[jumlahRetur]
					   ,[tglRetur]
					   ,[idUserEntry])
				 SELECT @idPenjualanDetail
					   ,a.jumlah
					   ,@jumlahRetur
					   ,@tglRetur
					   ,@idUserEntry
				   FROM dbo.farmasiPenjualanDetail a
				  WHERE a.idPenjualanDetail = @idPenjualanDetail;

			/*Respon*/
			Select 'Data Retur Berhasil Disimpan' As respon, 1 As responCode;
 		End
END