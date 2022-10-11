-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[labor_petugasLabor_entryPemeriksaan_addPemeriksaan]
	-- Add the parameters for the stored procedure here
	@idOrder bigint,
	@listPemeriksaan nvarchar(250),
	@idUserEntry int,
	@tglTindakan date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idTindakanPasien bigint
		   ,@idJenisBilling int;

	SELECT @idJenisBilling = CASE
								  WHEN b.idJenisPerawatan = 1/*Rawat Inap*/
									   THEN 6/*Billing Tagihan RaNap*/
								  ELSE 2/*Billing Tagihan Labor*/
							  END
	  FROM dbo.transaksiOrder a
		   INNER JOIN dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
	 WHERE a.idOrder = @idOrder;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @tablePemeriksaan Table(idMasterTarif int, idMasterTarifHeader int);
	DECLARE @listOrderDetail Table(idOrder bigint, idOrderDetail bigint);

	INSERT INTO @tablePemeriksaan
			   (idMasterTarif
			   ,idMasterTarifHeader)
		 SELECT DISTINCT value
			   ,b.idMasterTarifHeader
		   FROM String_Split(@listPemeriksaan, '|') a
				Inner Join dbo.masterTarip b On a.value = b.idMasterTarif
		  WHERE TRIM(value) <> '';

	IF EXISTS(SELECT TOP 1 1 FROM @tablePemeriksaan a LEFT JOIN dbo.masterLaboratoriumPemeriksaan b ON a.idMasterTarifHeader = b.idMasterTarifHeader
			   WHERE b.idPemeriksaanLaboratorium IS NULL)
		BEGIN
			SELECT TOP 1 'Pemeriksaan '+ c.namaTarifHeader +' Belum Terdaftar, Silahkan Entry Pada Master Pemeriksaan Laboratorium' AS respon, 0 AS responCode
			  FROM @tablePemeriksaan a 
				   LEFT JOIN dbo.masterLaboratoriumPemeriksaan b ON a.idMasterTarifHeader = b.idMasterTarifHeader
				   LEFT JOIN dbo.masterTarifHeader c ON a.idMasterTarifHeader = c.idMasterTarifHeader
			 WHERE b.idPemeriksaanLaboratorium IS NULL
		END
	ELSE
		BEGIN TRY
			/*Transaction Begin*/
			BEGIN TRAN;

			/*INSERT Data Order Detail*/
			INSERT INTO [dbo].[transaksiOrderDetail]
					   ([idOrder]
					   ,[idMasterTarif]
					   ,[idUserEntry])
				 OUTPUT inserted.idOrder
					   ,inserted.idOrderDetail
				   INTO @listOrderDetail
				 SELECT @idOrder
					   ,a.idMasterTarif
					   ,@idUserEntry
				   FROM @tablePemeriksaan a
						OUTER APPLY (SELECT xa.idOrderDetail
									   FROM dbo.transaksiOrderDetail xa
											INNER JOIN dbo.masterTarip xb ON xa.idMasterTarif = xb.idMasterTarif
									  WHERE xb.idMasterTarifHeader = a.idMasterTarifHeader AND xa.idOrder = @idOrder) b
				  WHERE b.idOrderDetail Is Null;

			/*INSERT Data Tindakan*/
			INSERT INTO [dbo].[transaksiTindakanPasien]
					   ([idPendaftaranPasien]
					   ,[idOrderDetail]
					   ,[idJenisBilling]
					   ,[idRuangan]
					   ,[idMasterTarif]
					   ,[tglTindakan]
					   ,[idUserEntry])
				 SELECT a.idPendaftaranPasien
					   ,b.idOrderDetail
					   ,@idJenisBilling
					   ,a.idRuanganTujuan
					   ,b.idMasterTarif
					   ,@tglTindakan
					   ,@idUserEntry
				   FROM dbo.transaksiOrder a
						INNER JOIN dbo.transaksiOrderDetail b ON a.idOrder = b.idOrder
							LEFT JOIN dbo.transaksiTindakanPasien ba ON b.idOrderDetail = ba.idOrderDetail
				  WHERE a.idOrder = @idOrder AND b.idUserEntry = @idUserEntry
						AND ba.idTindakanPasien IS NULL;

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
						INNER JOIN @listOrderDetail c ON a.idOrderDetail = c.idOrderDetail
				  WHERE c.idOrder = @idOrder;

			/*Transaction Commit*/
			COMMIT TRAN;
			SELECT 'Data Pemeriksaan Laboratorium Berhasil Disimpan' AS respon, 1 AS responCode;
		END TRY
		BEGIN CATCH
			/*Transaction Rollback*/
			ROLLBACK TRAN;
			SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, NULL AS responCode;
		END CATCH
END