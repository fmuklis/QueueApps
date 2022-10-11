-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE farmasi_mutasi_verifikasiDetail_validasi
	-- Add the parameters for the stored procedure here
	@idMutasi bigint,
	@tanggalDiserahkan date,
	@petugasPenyerahan varchar(50),
	@penerima varchar(50),
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiMutasi WHERE idMutasi = @idMutasi AND idStatusMutasi <> 3/*Request Diproses*/)
		BEGIN
			SELECT 'Tidak Dapat Divalidasi, Request Mutasi '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiMutasi a
				   LEFT JOIN dbo.farmasiMasterStatusMutasi b ON a.idStatusMutasi = b.idStatusMutasi
			 WHERE a.idMutasi = @idMutasi;
		END
	ELSE IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.farmasiMutasiOrderItem a
							  INNER JOIN dbo.farmasiMutasiRequestApproved b ON a.idItemOrderMutasi = b.idItemOrderMutasi
						WHERE a.idMutasi = @idMutasi)
		BEGIN
			SELECT 'Tidak Dapat Divalidasi, Item Mutasi Belum Dientry' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;
			
			/*Declare Variable Table*/
			DECLARE @listidMutasiRequestApproved table(idMutasiRequestApproved bigint);

			/*Update Stok Jika Sudah Ada Barang Yang Sama Sebelumnya*/
			UPDATE a
			   SET a.stok += bb.jumlahDisetujui
				  ,a.idMutasiRequestApproved = bb.idMutasiRequestApproved
			OUTPUT inserted.idMutasiRequestApproved
			  INTO @listidMutasiRequestApproved
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN dbo.farmasiMutasi b ON a.idJenisStok = b.idJenisStokTujuan
						INNER JOIN dbo.farmasiMutasiOrderItem ba ON b.idMutasi = ba.idMutasi
						INNER JOIN dbo.farmasiMutasiRequestApproved bb ON ba.idItemOrderMutasi = bb.idItemOrderMutasi
						INNER JOIN dbo.farmasiMasterObatDetail bc ON bb.idObatDetail = bc.idObatDetail AND (a.idObatDetailAsal = bc.idObatDetail OR a.idObatDetail = bc.idObatDetailAsal)
			 WHERE b.idMutasi = @idMutasi;

			/*Add Stok Barang Farmasi*/
			INSERT INTO [dbo].[farmasiMasterObatDetail]
					   ([kodeBatch]
					   ,[idJenisStok]
					   ,[tglExpired]
					   ,[stok]
					   ,[idUserEntry]
					   ,[idObatDosis]
					   ,[hargaPokok]
					   ,[idMetodeStok]
					   ,[tglStokAtauTglBeli]
					   ,[idPembelianDetail]
					   ,[idMutasiRequestApproved]
					   ,[idObatDetailAsal])
				 SELECT c.kodeBatch
					   ,ba.idJenisStokTujuan
					   ,c.tglExpired
					   ,a.jumlahDisetujui
					   ,a.idUserEntry
					   ,c.idObatDosis
					   ,c.hargaPokok
					   ,3/*Mutasi*/
					   ,c.tglStokAtauTglBeli
					   ,c.idPembelianDetail
					   ,a.idMutasiRequestApproved
					   ,COALESCE(c.idObatDetailAsal, c.idObatDetail)
				   FROM dbo.farmasiMutasiRequestApproved a
						INNER JOIN dbo.farmasiMutasiOrderItem b ON a.idItemOrderMutasi = b.idItemOrderMutasi
							INNER JOIN dbo.farmasiMutasi ba ON b.idMutasi = ba.idMutasi
						INNER JOIN dbo.farmasiMasterObatDetail c ON a.idObatDetail = c.idObatDetail
						LEFT JOIN @listidMutasiRequestApproved d ON a.idMutasiRequestApproved = d.idMutasiRequestApproved
				  WHERE b.idMutasi = @idMutasi AND d.idMutasiRequestApproved IS NULL;

			/*Create Jurnal Stok Masuk*/
			INSERT INTO [dbo].[farmasiJurnalStok]
					   ([idObatDetail]
					   ,[idMutasiRequestApproved]
					   ,[stokAwal]
					   ,[jumlahMasuk]
					   ,[stokAkhir]
					   ,[idUserEntry])
				 SELECT c.idObatDetail
					   ,a.idMutasiRequestApproved
					   ,c.stok - a.jumlahDisetujui
					   ,a.jumlahDisetujui
					   ,c.stok
					   ,a.idUserEntry
				   FROM dbo.farmasiMutasiRequestApproved a
						INNER JOIN dbo.farmasiMutasiOrderItem b ON a.idItemOrderMutasi = b.idItemOrderMutasi
						INNER JOIN dbo.farmasiMasterObatDetail c ON a.idMutasiRequestApproved = c.idMutasiRequestApproved
				  WHERE b.idMutasi = @idMutasi;

			/*Update Status Request Mutasi*/
			UPDATE dbo.farmasiMutasi
			   SET idStatusMutasi = 4/*Request Diterima*/
				  ,kodeMutasi = dbo.generate_kodeMutasi(@tanggalDiserahkan)
				  ,tanggalAprove = @tanggalDiserahkan
				  ,petugasPenerima = @penerima
				  ,petugasPenyerahan = @petugasPenyerahan
				  ,idUserVerifikasi = @idUserEntry
				  ,tanggalModifikasi = GETDATE()
			 WHERE idMutasi = @idMutasi;

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Request Mutasi Berhasil Divalidasi' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END