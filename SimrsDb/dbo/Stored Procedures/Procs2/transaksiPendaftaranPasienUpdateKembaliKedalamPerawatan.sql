
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienUpdateKembaliKedalamPerawatan] 
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idStatusPendaftaran int = Case
											When Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idJenisPerawatan = 1/*RaNap*/And idJenisPendaftaran In(1,2) And idPendaftaranPasien = @idPendaftaranPasien)
												 Then 5/*Dalam Perawatan Rawat Inap*/
											When Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idJenisPerawatan = 2/*RaJal*/ And idJenisPendaftaran = 1/*Reg IGD*/ And idPendaftaranPasien = @idPendaftaranPasien)
												 Then 3/*Dalam Perawatan IGD*/
											Else 2/*Dalam Perawatan RaJal*/
										End						  
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien And idStatusPendaftaran < 99)
		Begin
			Select 'Gagal!: Pasien Masih Dalam '+ b.namaStatusPendaftaran As respon, 0 As responCode
			  From dbo.transaksiPendaftaranPasien a
				   Inner Join dbo.masterStatusPendaftaran b On a.idStatusPendaftaran = b.idStatusPendaftaran
			 Where a.idPendaftaranPasien = @idPendaftaranPasien;
		End
	Else
		Begin
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = @idStatusPendaftaran
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;
			Select 'Berhasil, Pasien Dikembalikan Ke '+ namaStatusPendaftaran As respon, 1 As responCode
			  From dbo.masterStatusPendaftaran 
			 Where idStatusPendaftaran = @idStatusPendaftaran;
		End
END