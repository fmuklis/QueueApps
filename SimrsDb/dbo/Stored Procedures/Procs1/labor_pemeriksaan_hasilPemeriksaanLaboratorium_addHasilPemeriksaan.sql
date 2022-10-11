-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_hasilPemeriksaanLaboratorium_addHasilPemeriksaan]
	-- Add the parameters for the stored procedure here
	@idOrder bigint,
	@listHasilPemeriksaanLaboratorium varchar(max),
	@idUserOtorisasi int,
	@tanggalHasil datetime,
	@keterangan nvarchar(max),
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @listDataHasil table (idDetailItemPemeriksaanLaboratorium int, nilai nvarchar(225), valid bit);

	INSERT INTO @listDataHasil
			   (idDetailItemPemeriksaanLaboratorium
			   ,nilai
			   ,valid)
		 SELECT b.columnValue
			   ,c.columnValue
			   ,d.columnValue
		   FROM STRING_SPLIT(@listHasilPemeriksaanLaboratorium, '|') a
				OUTER APPLY(SELECT xa.columnValue
							  FROM dbo.getInfo_columnValueFromString(a.value) xa
							 WHERE xa.columnId = 1) b
				OUTER APPLY(SELECT xa.columnValue
							  FROM dbo.getInfo_columnValueFromString(a.value) xa
							 WHERE xa.columnId = 2) c
				OUTER APPLY(SELECT xa.columnValue
							  FROM dbo.getInfo_columnValueFromString(a.value) xa
							 WHERE xa.columnId = 3) d
		  WHERE a.value <> '';

	IF EXISTS(SELECT 1 FROM transaksiBillingHeader WHERE idOrder = @idOrder AND idStatusBayar = 1/*Menunggu Pembayaran*/)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Pemeriksaan Laboratorium Belum Dibayar' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.transaksiOrder WHERE idOrder = @idOrder AND idStatusOrder <> 3/*Selesai Pemeriksaan*/)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Pemeriksaan Laboratorium '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.transaksiOrder a
				   LEFT JOIN dbo.masterStatusOrder b ON a.idStatusOrder = b.idStatusOrder
			 WHERE a.idOrder = @idOrder;
		END
	ELSE IF NOT EXISTS(SELECT TOP 1 1 FROM @listDataHasil WHERE valid = 1)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Belum Ada Hasil Pemeriksaan Yang Valid' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT 1 FROM masterKonfigurasi WHERE idKonfigurasi = 1 AND idPenanggungJawabLaboratorium IS NULL)
		BEGIN
			SELECT 'Penanggung Jawab Laboratorium Belum Di Konfigurasi, Hubungi IT' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[transaksiPemeriksaanLaboratorium]
					   ([idTindakanPasien]
					   ,[idDetailItemPemeriksaanLaboratorium]
					   ,[nilai]
					   ,[nilaiRujukan]
					   ,[satuan]
					   ,[valid]
					   ,[idUserEntry])
				 SELECT a.idTindakanPasien
					   ,cb.idDetailItemPemeriksaanLaboratorium
					   ,cb.nilai
					   ,ca.nilaiRujukan
					   ,ca.satuan
					   ,cb.valid
					   ,@idUserEntry
				   FROM dbo.transaksiTindakanPasien a
						INNER JOIN dbo.transaksiOrderDetail b ON a.idOrderDetail = b.idOrderDetail AND b.idOrder = @idOrder
						INNER JOIN dbo.masterTarip c ON a.idMasterTarif = c.idMasterTarif
							CROSS APPLY dbo.getInfo_pemeriksaanLaboratorium(c.idMasterTarifHeader) ca
							INNER JOIN @listDataHasil cb ON ca.idDetailItemPemeriksaanLaboratorium = cb.idDetailItemPemeriksaanLaboratorium
						LEFT JOIN dbo.transaksiPemeriksaanLaboratorium d ON a.idTindakanPasien = d.idTindakanPasien AND ca.idDetailItemPemeriksaanLaboratorium = d.idDetailItemPemeriksaanLaboratorium
				  WHERE d.idPemeriksaanLaboratorium IS NULL;
			
			IF EXISTS(SELECT TOP 1 1 
						FROM dbo.transaksiTindakanPasien a
					 		 INNER JOIN dbo.transaksiOrderDetail b ON a.idOrderDetail = b.idOrderDetail AND b.idOrder = @idOrder
							 INNER JOIN dbo.masterTarip c ON a.idMasterTarif = c.idMasterTarif
								CROSS APPLY dbo.getInfo_pemeriksaanLaboratorium(c.idMasterTarifHeader) ca
						LEFT JOIN dbo.transaksiPemeriksaanLaboratorium d ON a.idTindakanPasien = d.idTindakanPasien AND ca.idDetailItemPemeriksaanLaboratorium = d.idDetailItemPemeriksaanLaboratorium
				  WHERE ISNULL(d.valid, 0) = 0)
				BEGIN
					UPDATE a
					   SET a.idStatusOrder = 4/*Proses Entry Hasil*/
						  ,idUserOtorisasi = @idUserOtorisasi
						  ,tanggalHasil = @tanggalHasil
						  ,idPenanggungJawabLaboratorium = b.idPenanggungJawabLaboratorium
						  ,keteranganHasilPemeriksaan = @keterangan
						  ,tanggalModifikasi = GETDATE()
					  FROM dbo.transaksiOrder  a
						   OUTER APPLY (SELECT idPenanggungJawabLaboratorium
										  FROM dbo.masterKonfigurasi
										 WHERE idKonfigurasi = 1) b
					 WHERE idOrder = @idOrder;
				END
			ELSE
				BEGIN
					UPDATE a
					   SET a.idStatusOrder = 5/*Hasil Pemeriksaan Diotorisasi*/
						  ,idUserOtorisasi = @idUserOtorisasi
						  ,tanggalHasil = @tanggalHasil
						  ,idPenanggungJawabLaboratorium = b.idPenanggungJawabLaboratorium
						  ,keteranganHasilPemeriksaan = @keterangan
						  ,tanggalModifikasi = GETDATE()
					  FROM dbo.transaksiOrder  a
						   OUTER APPLY (SELECT idPenanggungJawabLaboratorium
										  FROM dbo.masterKonfigurasi
										 WHERE idKonfigurasi = 1) b
					 WHERE idOrder = @idOrder;
				END

			SELECT 'Hasil Pemeriksaan Laboratorium Berhasil Disimpan' AS respon, 1 AS responCode;
		END
END