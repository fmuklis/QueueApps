﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasiMasterObatDetailUpdateForStokOpnameBHP]
	-- Add the parameters for the stored procedure here
	@idObatDetail int
	,@kodeBatch nvarchar(50)
	,@tglExpired date
	,@stok numeric(18,2)
	,@hargaPokok money
	,@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStok int
		   ,@persentaseHargaJual decimal(18,2) = (Select persentaseHargaJualFarmasi From dbo.masterKonfigurasi)
		   ,@idObatDosis int;

	Select @idJenisStok = idJenisStok, @idObatDosis = idObatDosis 
	  From dbo.farmasiMasterObatDetail 
	 Where idObatDetail = @idObatDetail;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*If @kodeBatch Is Null
		Begin
			Select 'Gagal!: Kode Batch Kosong' As respon, 0 As responCode;
		End
	Else If IsNull(@hargaPokok, 0) < 1
		Begin
			Select 'Gagal!: Harga Pokok Kosong' As respon, 0 As responCode;
		End
	Else If @tglExpired <= Convert(date, GetDate())
		Begin
			Select 'Gagal!: Obat Telah Expired, Tidak Dapat Dijual' As respon, 0 As responCode;
		End
	Else If @stok < 1
		Begin
			Select 'Gagal!: Stok Masih Kosong' As respon, 0 As responCode;
		End						
	Else If Exists(Select 1 From dbo.farmasiPenjualanDetail Where idObatDetail = @idObatDetail)
		Begin
			Select 'Tidak Dapat Diubah, Lakukan Koreksi Stok' As respon, 0 As responCode;
		End
	Else
		Begin Try
			Begin Tran tranzSOBHPRuanganUpd;
			/*UPDATE Data Obat*/
			UPDATE dbo.farmasiMasterObatDetail
			   SET [kodeBatch] = @kodeBatch
				  ,[tglExpired] = @tglExpired
				  ,[stok] = @stok
				  ,[hargaPokok] = @hargaPokok
				  ,[idUserEntry] = @idUserEntry
			 WHERE idObatDetail = @idObatDetail;

			/*UPDATE Tabel Stok Opname*/
			UPDATE dbo.farmasiStokOpname
			   SET [hargaPokok] = @hargaPokok
				  ,[koreksiStokIN] = @stok
				  ,[idUserEntry] = @idUserEntry
			 WHERE idObatDetail = @idObatDetail;

			/*Update Harga Jual*/
			UPDATE a
			   SET hargaJual = b.hargaPokok + (b.hargaPokok * @persentaseHargaJual / 100)
			  FROM dbo.farmasiMasterObatDosis a
				   Inner Join (Select xa.idObatDosis, Max(xa.hargaPokok) As hargaPokok 
								 From dbo.farmasiMasterObatDetail xa
							 Group By xa.idObatDosis) b On a.idObatDosis = b.idObatDosis 
			 WHERE a.idObatDosis = @idObatDosis;

			/*UPDATE Log Farmasi*/
			UPDATE dbo.farmasiJurnalStok
			   SET jumlahMasuk = @stok
			      ,[tglEntry] = GetDate()
			      ,[idUserEntry] = @idUserEntry
			 WHERE idObatDetail = @idObatDetail;

			Commit Tran tranzSOBHPRuanganUpd;

			Select 'Stok BHP Ruangan Berhasil Diupdate' As respon, 1 As responCode;
		End Try
		Begin Catch
			Rollback Tran tranzSOBHPRuanganUpd;
			Select 'Error !: ' + ERROR_MESSAGE() As respon, 0 responCode;
		End Catch*/
END