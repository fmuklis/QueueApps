-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_returKegudangDetail_konfirmasiRetur]
	-- Add the parameters for the stored procedure here
	@idRetur bigint,
	@idPenerima int,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiRetur WHERE idRetur = @idRetur AND idStatusRetur <> 5/*Request Valid*/)
		BEGIN
			SELECT 'Tidak Dapat Diproses, '+ b.caption
			  FROM dbo.farmasiRetur a
				   LEFT JOIN dbo.farmasiMasterStatusRetur b ON a.idStatusRetur = b.idStatusRetur
			 WHERE a.idRetur = @idRetur;
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			DECLARE @listUpdatedStock table(idObatDetail bigint);
			DECLARE @listInsertStock table(idObatDetail bigint);
			
			/*Update Stok Dengan IdObatDetailAsal Yang Sama*/
			UPDATE a
			   SET a.stok += ISNULL(ba.jumlahRetur, 0)
			OUTPUT inserted.idObatDetail
			  INTO @listUpdatedStock
			  FROM dbo.farmasiMasterObatDetail a
				   INNER JOIN farmasiMasterObatDetail b ON a.idObatDetail = b.idObatDetailAsal OR a.idObatDetailAsal = b.idObatDetailAsal
						INNER JOIN dbo.farmasiReturDetail ba ON b.idObatDetail = ba.idObatDetail
						INNER JOIN dbo.farmasiRetur bb ON ba.idRetur = bb.idRetur
			 WHERE ba.idRetur = @idRetur AND a.idJenisStok = bb.idJenisStokTujuan;

			/*Add Jural Stok Masuk*/
			INSERT INTO [dbo].[farmasiJurnalStok]
					   ([idObatDetail]
					   ,[idReturDetail]
					   ,[stokAwal]
					   ,[jumlahMasuk]
					   ,[stokAkhir]
					   ,[idUserEntry])
				 SELECT a.idObatDetail
					   ,c.idReturDetail
					   ,b.stok - c.jumlahRetur
					   ,c.jumlahRetur
					   ,b.stok
					   ,@idUserEntry
				   FROM @listUpdatedStock a
						INNER JOIN dbo.farmasiMasterObatDetail b ON a.idObatDetail = b.idObatDetail
							CROSS APPLY (SELECT xb.idReturDetail, xb.jumlahRetur
										   FROM dbo.farmasiRetur xa
												INNER JOIN dbo.farmasiReturDetail xb ON xa.idRetur = xb.idRetur
												INNER JOIN dbo.farmasiMasterObatDetail xc ON xb.idObatDetail = xc.idObatDetail
										  WHERE xa.idRetur = @idRetur AND xa.idJenisStokTujuan = b.idJenisStok AND (xc.idObatDetailAsal = b.idObatDetail OR xc.idObatDetailAsal = b.idObatDetailAsal)) c;

			/*Add Stok*/
			INSERT INTO [dbo].[farmasiMasterObatDetail]
					   ([idMetodeStok]
					   ,[idJenisStok]
					   ,[idObatDosis]
					   ,[kodeBatch]
					   ,[tglExpired]
					   ,[tglStokAtauTglBeli]
					   ,[stok]
					   ,[hargaPokok]
					   ,[idPembelianDetail]
					   ,[idObatDetailAsal]
					   ,[idUserEntry])
				 OUTPUT inserted.idObatDetail
				   INTO @listInsertStock
				 SELECT c.idMetodeStok
					   ,b.idJenisStokTujuan
					   ,c.idObatDosis
					   ,c.kodeBatch
					   ,c.tglExpired
					   ,c.tglStokAtauTglBeli
					   ,a.jumlahRetur
					   ,c.hargaPokok
					   ,c.idPembelianDetail
					   ,c.idObatDetail
					   ,@idUserEntry
				   FROM dbo.farmasiReturDetail a
						INNER JOIN dbo.farmasiRetur b ON a.idRetur = b.idRetur
						INNER JOIN dbo.farmasiMasterObatDetail c ON a.idObatDetail = c.idObatDetail
							LEFT JOIN dbo.farmasiMasterObatDetail ca ON c.idObatDetailAsal = ca.idObatDetail OR c.idObatDetailAsal = ca.idObatDetailAsal AND b.idJenisStokTujuan = ca.idJenisStok
				  WHERE a.idRetur = @idRetur AND ca.idObatDetail IS NULL;

			/*Add Jural Stok Masuk*/
			INSERT INTO [dbo].[farmasiJurnalStok]
					   ([idObatDetail]
					   ,[idReturDetail]
					   ,[jumlahMasuk]
					   ,[stokAkhir]
					   ,[idUserEntry])
				 SELECT a.idObatDetail
					   ,b.idReturDetail
					   ,b.jumlahRetur
					   ,b.jumlahRetur
					   ,@idUserEntry
				   FROM @listInsertStock a
						INNER JOIN dbo.farmasiReturDetail b ON a.idObatDetail = b.idObatDetail
				  WHERE b.idRetur = @idRetur;

			/*Update Status Retur*/
			UPDATE farmasiRetur
			   SET idStatusRetur = 10/*Request Cofirmed*/
				  ,idPenerima = @idPenerima
				  ,tanggalModifikasi = GETDATE()
			 WHERE idRetur = @idRetur;

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Permintaan Retur Barang Farmasi Dikonfirmasi' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END