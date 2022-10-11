-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
create PROCEDURE [dbo].[ugd_perawatUgd_entryTindakan_addKonsul]
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int
	,@idRuanganTujuan int
	,@tglOrderKonsul datetime
	,@idUserEntry int
	,@alasanKonsul nvarchar(max)
	,@konsulYangDiminta nvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idRuanganAsal int = (Select idRuangan From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien);
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	If Not Exists (Select 1 From dbo.transaksiKonsul Where idPendaftaranPasien = @idPendaftaranPasien And idRuanganTujuan = @idRuanganTujuan And idStatusKonsul = 1)
		Begin
			INSERT INTO dbo.transaksiKonsul
					   (idPendaftaranPasien
					   ,idRuanganAsal
					   ,idRuanganTujuan
					   ,tglOrderKonsul
					   ,idStatusKonsul
					   ,idUserEntry
					   ,alasan
					   ,itemKonsul)
				 VALUES
					   (@idPendaftaranPasien
					   ,@idRuanganAsal
					   ,@idRuanganTujuan
					   ,GETDATE()
					   ,1
					   ,@idUserEntry
					   ,@alasanKonsul
					   ,@konsulYangDiminta);
			Select 'Data Permintaan Konsul Berhasil Disimpan' As respon, 1 As responCode;
		End
	Else
		Begin
			Select 'Sudah Ada Permintaan Konsul Yang Sama Belum Diproses' As respon, 0 As responCode;
		End
END