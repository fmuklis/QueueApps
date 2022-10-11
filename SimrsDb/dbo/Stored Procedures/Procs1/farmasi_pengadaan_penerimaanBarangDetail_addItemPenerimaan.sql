-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_pengadaan_penerimaanBarangDetail_addItemPenerimaan] 
	-- Add the parameters for the stored procedure here
	@idPembelianHeader int,
	@listItemPenerimaan nvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

	DECLARE @dataItemPenerimaan table
		   (idOrderDetail int, kodeBatch nvarchar(50), tglExpired date, jumlahBeli decimal(18,2)
		   ,hargaBeli money, discountPersen decimal(18,2), discountUang money);

	INSERT INTO @dataItemPenerimaan
			   (idOrderDetail, kodeBatch, tglExpired, jumlahBeli
			   ,hargaBeli, discountPersen, discountUang)
		 SELECT b.[1], b.[2], b.[3], b.[4]
			   ,b.[5], b.[6], b.[7]
		   FROM string_split(@listItemPenerimaan, '|') a
				OUTER APPLY dbo.generate_stringTable(a.value) b
		  WHERE b.[1] IS NOT NULL;

    -- Insert statements for procedure here

	IF EXISTS(SELECT 1 FROM @dataItemPenerimaan WHERE DATEDIFF(DAY, GETDATE(), tglExpired) <= 0)
		Begin
			Select 'Tidak Dapat Disimpan, Barang Pesanan Telah Expired' AS respon, 0 AS responCode;
		End
	ELSE IF EXISTS(SELECT 1 FROM @dataItemPenerimaan WHERE ISNULL(jumlahBeli, 0) = 0)
		Begin
			Select 'Tidak Dapat Disimpan, Jumlah Penerimaan Barang Pesanan Kosong' As respon, 0 As responCode;
		End
	ELSE IF EXISTS(SELECT 1 FROM @dataItemPenerimaan WHERE LEN(ISNULL(kodeBatch, '')) = 0)
		Begin
			Select 'Tidak Dapat Disimpan, Kode Batch Penerimaan Barang Pesanan Kosong' As respon, 0 As responCode;
		End
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiPembelianDetail a
					 INNER JOIN @dataItemPenerimaan b ON a.idOrderDetail = b.idOrderDetail AND a.kodeBatch = b.kodeBatch
			   WHERE a.idPembelianHeader = @idPembelianHeader)
		BEGIN
			Select 'Tidak Dapat Disimpan, Item Penerimaan Barang Telah Terdaftar' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiOrderDetail a 
						  LEFT JOIN dbo.farmasiPembelianDetail b ON a.idOrderDetail = b.idOrderDetail
						  INNER JOIN @dataItemPenerimaan c ON b.idOrderDetail = c.idOrderDetail
				 GROUP BY a.idOrderDetail, a.jumlah, c.jumlahBeli
				   HAVING a.jumlah < c.jumlahBeli + SUM(ISNULL(b.jumlahBeli, 0)))
		Begin
			Select 'Tidak Dapat Disimpan, Jumlah Penerimaan Melebihi Jumlah Barang Yang Dipesan' AS respon, 0 AS responCode;
		End
	Else
		Begin Try
			Begin Tran;

			INSERT INTO [dbo].[farmasiPembelianDetail]
					   ([idPembelianHeader]
					   ,[kodeBatch]
					   ,[tglExpired]
					   ,[jumlahBeli]
					   ,[hargaBeli]
					   ,[discountPersen]
					   ,[discountUang]
					   ,[idOrderDetail])
				 SELECT @idPembelianHeader
					   ,kodeBatch
					   ,tglExpired
					   ,jumlahBeli
					   ,hargaBeli
					   ,discountPersen
					   ,discountUang
					   ,idOrderDetail
				   FROM @dataItemPenerimaan;

			/*Update Status Order Proses Entry Faktur*/
			UPDATE a
			   SET a.idStatusOrder = 3/*Entry Penerimaan*/
			  FROM dbo.farmasiOrder a
				   INNER JOIN dbo.farmasiOrderDetail b ON a.idOrder = b.idOrder
						INNER JOIN dbo.farmasiPembelianDetail ba ON b.idOrderDetail = ba.idOrderDetail
						INNER JOIN @dataItemPenerimaan bb ON b.idOrderDetail = bb.idOrderDetail
			 WHERE a.idStatusOrder = 2/*Order Valid*/;

			Commit Tran;
			Select 'Data Penerimaan Barang Faramsi Berhasil Disimpan' AS respon, 1 AS responCode;
		End Try
		Begin Catch
			Rollback Tran;
			Select 'Error!: '+ ERROR_MESSAGE() As respon, NULL As responCode; 
		End Catch
END