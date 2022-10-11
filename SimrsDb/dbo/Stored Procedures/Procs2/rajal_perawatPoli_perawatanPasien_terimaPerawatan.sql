-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[rajal_perawatPoli_perawatanPasien_terimaPerawatan]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			Select 'Data Tidak Ditemukan' As respon, 0 As responCode;
		End
	Else
		Begin
			UPDATE [dbo].[transaksiPendaftaranPasien]
			   SET [idStatusPendaftaran] = 2/*Perawatan*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			Select 'Pasien Diterima, Dan Dalam Perawatan '+ b.namaRuangan As respon, 1 As responCode
			  From dbo.transaksiPendaftaranPasien a
				   Inner Join dbo.masterRuangan b On a.idRuangan = b.idRuangan
			 Where a.idPendaftaranPasien = @idPendaftaranPasien; 
		End
END