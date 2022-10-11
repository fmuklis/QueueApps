-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_pemeriksaan_hasilPemeriksaanLaboratorium_editHasilPemeriksaan]
	-- Add the parameters for the stored procedure here
	@idOrder bigint,
	@listEditHasilPemeriksaanLaboratorium varchar(max),
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
	DECLARE @listEditDataHasil table (idDetailItemPemeriksaanLaboratorium int, nilai nvarchar(225), valid bit);

	INSERT INTO @listEditDataHasil
			   (idDetailItemPemeriksaanLaboratorium
			   ,nilai
			   ,valid)
		 SELECT b.columnValue
			   ,c.columnValue
			   ,d.columnValue
		   FROM STRING_SPLIT(@listEditHasilPemeriksaanLaboratorium, '|') a
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
	ELSE IF EXISTS(SELECT 1 FROM dbo.transaksiOrder WHERE idOrder = @idOrder AND idStatusOrder <> 4/*Proses Entry Hasil*/)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Pemeriksaan Laboratorium '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.transaksiOrder a
				   LEFT JOIN dbo.masterStatusOrder b ON a.idStatusOrder = b.idStatusOrder
			 WHERE a.idOrder = @idOrder;
		END
	ELSE IF NOT EXISTS(SELECT TOP 1 1 FROM @listEditDataHasil WHERE valid = 1)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Belum Ada Hasil Pemeriksaan Yang Valid' AS respon, 0 AS responCode;
		END
	ELSE IF EXISTS(SELECT 1 FROM masterKonfigurasi WHERE idKonfigurasi = 1 AND idPenanggungJawabLaboratorium IS NULL)
		BEGIN
			SELECT 'Penanggung Jawab Laboratorium Belum Di Konfigurasi, Hubungi IT' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			/*Edit Hasil Yang Belum Divalidasi*/
			UPDATE a
			   SET a.nilai = c.nilai
				  ,a.nilaiRujukan = bc.nilaiRujukan
				  ,a.satuan = bc.satuan
				  ,a.valid = c.valid
				  ,a.idUserEntry = @idUserEntry
			  FROM dbo.transaksiPemeriksaanLaboratorium a
				   INNER JOIN dbo.transaksiTindakanPasien b ON a.idTindakanPasien = b.idTindakanPasien
						INNER JOIN dbo.transaksiOrderDetail ba ON b.idOrderDetail = ba.idOrderDetail AND ba.idOrder = @idOrder
						INNER JOIN dbo.masterTarip bb ON b.idMasterTarif = bb.idMasterTarif
						CROSS APPLY dbo.getInfo_pemeriksaanLaboratorium(bb.idMasterTarifHeader) bc
				   INNER JOIN @listEditDataHasil c ON a.idDetailItemPemeriksaanLaboratorium = c.idDetailItemPemeriksaanLaboratorium
							  AND bc.idDetailItemPemeriksaanLaboratorium = c.idDetailItemPemeriksaanLaboratorium
			 WHERE a.valid = 0/*Belum Valid*/;
			
			/*Entry Hasil Baru*/
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
							INNER JOIN @listEditDataHasil cb ON ca.idDetailItemPemeriksaanLaboratorium = cb.idDetailItemPemeriksaanLaboratorium
						LEFT JOIN dbo.transaksiPemeriksaanLaboratorium d ON a.idTindakanPasien = d.idTindakanPasien AND ca.idDetailItemPemeriksaanLaboratorium = d.idDetailItemPemeriksaanLaboratorium
				  WHERE d.idPemeriksaanLaboratorium IS NULL;

			/*Update Data Pemeriksaan*/
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

			SELECT 'Hasil Pemeriksaan Laboratorium Berhasil Diupdate' AS respon, 1 AS responCode;
		END
END