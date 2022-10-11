-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranUGD_editPendaftaranUmum]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int,
	@tglDaftarPasien datetime,
	@idAsalPasien int,
	@rujukan bit,
	@idOperator int,
	@idJenisPenjamin int,
	@keterangan nvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien And idStatusPendaftaran < 98)
		Begin
			Select 'Tidak Dapat Diupdate, Pasien Sedang ' + b.namaStatusPendaftaran As respon, 0 As responCode
			  From dbo.transaksiPendaftaranPasien a
				   Inner Join dbo.masterStatusPendaftaran b On a.idStatusPendaftaran = b.idStatusPendaftaran
			 Where a.idPendaftaranPasien = @idPendaftaranPasien;
		End
	Else
		Begin
			UPDATE [dbo].[transaksiPendaftaranPasien]
			   SET [tglDaftarPasien] = @tglDaftarPasien
				  ,[rujukan] = @rujukan
				  ,[idAsalPasien] = @idAsalPasien
				  ,[idDokter] = @idOperator
				  ,[keterangan] = @keterangan
			WHERE idPendaftaranPasien = @idPendaftaranPasien;

			Select 'Data Pendaftaran Berhasil Diupdate' As respon, 1 As responCode;
		End	
END