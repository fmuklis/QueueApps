-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Daftar Pasien Permintaan Perawatan
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[operasi_tindakan_dashboard_terimaPermintaanOperasi]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (SELECT 1 FROM dbo.transaksiOrderOK WHERE idPendaftaranPasien = @idPendaftaranPasien AND tglJadwal IS NULL)
		BEGIN
			Select 'Operasi belum dijadwalkan' AS respon, 0 AS responCode;
		END

	ELSE If Exists(Select 1 From dbo.transaksiOrderOK Where idPendaftaranPasien = @idPendaftaranPasien And idStatusOrderOK = 1)
		Begin
			UPDATE [dbo].[transaksiOrderOK]
			   SET [idStatusOrderOK] = 2/*Dalam Proses Operasi*/
			 WHERE [idPendaftaranPasien] = @idPendaftaranPasien;

			Select 'Pasien Diterima OK' AS respon, 1 AS responCode, idTransaksiOrderOK
			  FROM dbo.transaksiOrderOK
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;
		End
	Else
		Begin
			Select 'Tidak Dapat Diterima '+ b.[statusOperasi] As respon, 0 As responCode
			  From dbo.transaksiOrderOK a
				   LEFT JOIN dbo.masterStatusRequestOK b On a.idStatusOrderOK = b.idStatusOrderOK
			 Where a.idPendaftaranPasien = @idPendaftaranPasien;
		End
END