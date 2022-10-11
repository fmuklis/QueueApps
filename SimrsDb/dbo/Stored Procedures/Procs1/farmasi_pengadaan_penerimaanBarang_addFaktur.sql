-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menyimpan Data Pembelian Obat
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_pengadaan_penerimaanBarang_addFaktur]
	-- Add the parameters for the stored procedure here
	 @noFaktur nvarchar(50)
    ,@idOrder int
    ,@tglPembelian date
    ,@userIdEntry int
    ,@keterangan nvarchar(max)
	,@tglJatuhTempoPembayaran date
	,@ppn decimal(18,2)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From [dbo].[farmasiPembelian] Where [noFaktur] = @noFaktur)
		Begin
			Select 'Nomor Faktur '+ @noFaktur +' Telah Terdaftar' As respon, 0 As responCode;
		End
	ELSE IF NOT EXISTS(SELECT 1 FROM dbo.farmasiOrderDetail a LEFT JOIN dbo.farmasiPembelianDetail b ON a.idOrderDetail = b.idOrderDetail
						WHERE a.idOrder = @idOrder
					 GROUP BY a.idOrderDetail, a.jumlah
					   HAVING a.jumlah > SUM(ISNULL(b.jumlahBeli, 0)))
		BEGIN
			SELECT 'Faktur Tidak Dapat Disimpan, Jumlah Pesanan Telah Sesuai Dengan Barang Diterima' AS respon, 0 AS responCode;
		END
	Else
		Begin
			INSERT INTO [dbo].[farmasiPembelian]
					   ([noFaktur]
					   ,[idOrder]
					   ,[tglPembelian]
					   ,[tglEntry]
					   ,[userIdEntry]
					   ,[keterangan]
					   ,[tglJatuhTempoPembayaran]
					   ,[ppn])
				 SELECT @noFaktur
					   ,a.idOrder
					   ,@tglPembelian
					   ,GetDate()
					   ,@userIdEntry
					   ,@keterangan
					   ,@tglJatuhTempoPembayaran
					   ,@ppn
				   FROM dbo.farmasiOrder a
				  WHERE a.idOrder = @idOrder;

			Select 'Data Faktur Berhasil Disimpan' As respon, @noFaktur As nofaktur, SCOPE_IDENTITY() As idPembelianHeader, 1 As responCode;
		End
END