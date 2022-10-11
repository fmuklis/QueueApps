-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Daftar Pasien Permintaan Perawatan
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiOrderOKSelesaiUpdate]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.transaksiTindakanPasien Where idPendaftaranPasien = @idPendaftaranPasien And idRuangan = 24/*Instalasi OK*/)
		Begin
			Select 'Gagal!. Belum Ada Tindakan Pada Pasien Ini' As respon, 0 As responCode;
		End
	Else
		BEgin
			UPDATE [dbo].[transaksiOrderOK]
			   SET [idStatusOrderOK] = 3/*Selesai Operasi*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;
			Select 'Pasien Selesai Operasi' As respon, 1 As responCode;

			UPDATE a
			   SET a.idRuangan = b.idRuanganAsal
			  FROM dbo.transaksiPendaftaranPasien a
				   Inner Join dbo.transaksiOrderOK b On a.idPendaftaranPasien = b.idPendaftaranPasien
			 WHERE a.idPendaftaranPasien = @idPendaftaranPasien;
		End
END