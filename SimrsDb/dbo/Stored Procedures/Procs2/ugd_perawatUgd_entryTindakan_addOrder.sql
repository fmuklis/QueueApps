-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
create PROCEDURE [dbo].[ugd_perawatUgd_entryTindakan_addOrder]
	-- Add the parameters for the stored procedure here
	--Ttransaksi Order
	@idPendaftaranPasien int
	,@idDokter int
    ,@idRuanganAsal int
	,@idRuanganTujuan int
    ,@tglOrder datetime
	,@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.transaksiOrder Where idPendaftaranPasien = @idPendaftaranPasien And idRuanganTujuan = @idRuanganTujuan And idStatusOrder = 1)
		Begin
			INSERT INTO [dbo].[transaksiOrder]
					   ([idDokter]
					   ,[idRuanganAsal]
					   ,[idRuanganTujuan]
					   ,[idPendaftaranPasien]
					   ,[tglOrder]
					   ,[idUserEntry]
					   ,[idStatusOrder])
				 VALUES(@idDokter
					   ,@idRuanganAsal
					   ,@idRuanganTujuan
					   ,@idPendaftaranPasien 
					   ,@tglOrder
					   ,@idUserEntry
					   ,1);	
			Select 'Order Pemeriksaan Penunjang Berhasil Disimpan' As respon, 1 As responCode;								
		End
	Else
		Begin
			Select 'Gagal!: Masih Ada '+ b.namaStatusOrder +' Di '+ c.namaRuangan +' Pada Pasien Ini' As respon, 0 As responCode 
			  From dbo.transaksiOrder a
				   Inner Join dbo.masterStatusOrder b On a.idStatusOrder = b.idStatusOrder
				   Inner Join dbo.masterRuangan c On a.idRuanganTujuan = c.idRuangan
			 Where a.idPendaftaranPasien = @idPendaftaranPasien And a.idStatusOrder < 3
		End					
END