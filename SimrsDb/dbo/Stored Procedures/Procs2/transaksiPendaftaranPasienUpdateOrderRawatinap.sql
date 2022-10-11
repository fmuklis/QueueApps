
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienUpdateOrderRawatinap] 
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int
	,@idOrderRawatInap int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idRuangan int;
	Select @idRuangan = a.idRuangan from transaksiPendaftaranPasien a where a.idPendaftaranPasien = @idPendaftaranPasien;
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select Top 1 1 From transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			If exists(Select 1 from transaksiTindakanPasien a
			inner join dbo.masterRuangan b on a.idRuangan = b.idRuangan
			inner join dbo.transaksiPendaftaranPasien c on a.idPendaftaranPasien = c.idPendaftaranPasien
			 where a.idPendaftaranPasien = @idPendaftaranPasien and c.idOrderRawatInap = 4 and b.idJenisRuangan = 1)
			begin
				Select 'Data idak bisa dibatalkan lagi karena sudah ada tindakan' as respon, 0as responCode;
			End
			else
			Begin
				UPDATE dbo.transaksiPendaftaranPasien
				SET idOrderRawatInap = @idOrderRawatInap
				WHERE idPendaftaranPasien = @idPendaftaranPasien;

				if @idOrderRawatInap = 2
				Begin
					If not exists(Select 1 from transaksiOrderRawatInap where idPenDaftaranPasien = @idPendaftaranPasien)
					Begin
						INSERT INTO [dbo].[transaksiOrderRawatInap]
					   ([idPendaftaranPasien]
					   ,[idRuanganAsal]
					   ,[tglOrder])
				 VALUES
					   (@idPendaftaranPasien
					   ,@idRuangan
					   ,getdate());
					End
				End
				else If @idOrderRawatInap = 1
				Begin
					delete from transaksiOrderRawatInap where idPenDaftaranPasien = @idPendaftaranPasien;
				End

				Select 'Data Berhasil Diupdate' as respon, 1 as responCode;
			End
		End
	Else
		Begin
			Select 'Data Tidak Ditemukan' as respon, 0 as responCode;
		End
END