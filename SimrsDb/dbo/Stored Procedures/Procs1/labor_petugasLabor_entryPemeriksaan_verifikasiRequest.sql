-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_petugasLabor_entryPemeriksaan_verifikasiRequest]
	-- Add the parameters for the stored procedure here
	@idOrderDetail bigint,
	@idKelas tinyint,
	@idUserEntry int,
	@tglTindakan date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idTindakanPasien bigint
		   ,@idJenisBilling int
		   ,@idOrder bigint
		   ,@idMasterTarif bigint;

	SELECT @idJenisBilling = CASE
								  WHEN b.idJenisPerawatan = 1/*Rawat Inap*/
									   THEN 6/*Billing Tagihan RaNap*/
								  ELSE 2/*Billing Tagihan Labor*/
							  END
		  ,@idOrder = a.idOrder
	  FROM dbo.transaksiOrder a
		   INNER JOIN dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
		   INNER JOIN dbo.transaksiOrderDetail c ON a.idOrder = c.idOrder
	 WHERE c.idOrderDetail = @idOrderDetail;

	SELECT @idMasterTarif = ba.idMasterTarif
	  FROM dbo.transaksiOrderDetail a
		   INNER JOIN dbo.masterTarip b ON a.idMasterTarif = b.idMasterTarif
				INNER JOIN dbo.masterTarip ba ON b.idMasterTarifHeader = ba.idMasterTarifHeader
				INNER JOIN dbo.masterRuanganPelayanan bb ON ba.idMasterPelayanan = bb.idMasterPelayanan
	 WHERE a.idOrderDetail = @idOrderDetail AND ba.idKelas = @idKelas AND bb.idRuangan = 21/*Labor*/;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiOrder WHERE idOrder = @idOrder AND idStatusOrder <> 2/*Request Diterima*/)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.transaksiOrder a
				   LEFT JOIN dbo.masterStatusOrder b ON a.idStatusOrder = b.idStatusOrder
			  WHERE idOrder = @idOrder;
		END
	ELSE IF @idMasterTarif IS NULL
		BEGIN
			SELECT 'Biaya Pemeriksaan'+ b.namaTarif +' Kelas: '+ c.namaKelas +' Tidak Ditemukan, Hubungi Keuangan' AS respon, 0 AS responCode
			  FROM dbo.transaksiOrderDetail a
				   OUTER APPLY dbo.getInfo_tarif(a.idMasterTarif) b
				   OUTER APPLY (SELECT namaKelas FROM masterKelas WHERE idKelas = @idKelas) c
			 WHERE a.idOrderDetail = @idOrderDetail;
		END
	ELSE IF EXISTS(SELECT 1 
					 FROM dbo.transaksiTindakanPasien a
						  LEFT JOIN dbo.masterTarip b ON a.idMasterTarif = b.idMasterTarif
								LEFT JOIN dbo.masterTarip ba ON b.idMasterTarifHeader = ba.idMasterTarifHeader
					WHERE a.idOrderDetail = @idOrderDetail AND ba.idMasterTarif = @idMasterTarif)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Sudah Ada Data Pemeriksaan Yang Sama' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			/*INSERT Data Tindakan*/
			INSERT INTO [dbo].[transaksiTindakanPasien]
					   ([idPendaftaranPasien]
					   ,[idOrderDetail]
					   ,[idJenisBilling]
					   ,[idRuangan]
					   ,[idMasterTarif]
					   ,[tglTindakan]
					   ,[idUserEntry])
				 SELECT b.idPendaftaranPasien
					   ,a.idOrderDetail
					   ,@idJenisBilling
					   ,b.idRuanganTujuan
					   ,@idMasterTarif
					   ,@tglTindakan
					   ,@idUserEntry
				   FROM dbo.transaksiOrderDetail a
						INNER JOIN dbo.transaksiOrder b ON a.idOrder = b.idOrder
				  WHERE a.idOrderDetail = @idOrderDetail;

			/*INSERT Data Tindakan Detail*/
			INSERT INTO [dbo].[transaksiTindakanPasienDetail]
					   ([idTindakanPasien]
					   ,[idMasterKatagoriTarip]
					   ,[nilai])
				 SELECT a.idTindakanPasien
					   ,b.idMasterKatagoriTarip
					   ,b.tarip
				   FROM dbo.transaksiTindakanPasien a
						INNER JOIN dbo.masterTaripDetail b ON a.idMasterTarif = b.idMasterTarip AND b.[status] = 1
				  WHERE a.idOrderDetail = @idOrderDetail;

			SELECT 'Data Pemeriksaan Laboratorium Berhasil Disimpan' AS respon, 1 AS responCode;
		END
END