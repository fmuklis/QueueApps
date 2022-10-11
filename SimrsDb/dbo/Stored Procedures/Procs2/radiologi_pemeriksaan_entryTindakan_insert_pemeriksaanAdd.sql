-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[radiologi_pemeriksaan_entryTindakan_insert_pemeriksaanAdd]
	-- Add the parameters for the stored procedure here
	@idOrder bigint,
	@listPemeriksaan nvarchar(250),
	@idUserEntry int,
	@tglTindakan date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idTindakanPasien int
		   ,@idJenisBilling int
		   ,@pasienInap bit = Case
								   When Exists(Select 1 From dbo.transaksiOrder a
													  Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
												Where a.idOrder = @idOrder And b.idJenisPerawatan = 1/*Rawat Inap*/)
										Then 1
								   Else 0
							  End;

	SELECT @idJenisBilling = CASE
								  WHEN b.idJenisPerawatan = 2/*RaJal*/ AND b.idJenisPendaftaran IN(1,2) AND c.idJenisPenjaminInduk = 1/*UMUM*/
									   THEN 4/*Billing Tagihan Radiologi*/
								  WHEN b.idJenisPerawatan = 2/*Rawat Jalan*/ And b.idJenisPendaftaran = 2/*Poli RaJal*/ AND c.idJenisPenjaminInduk = 2/*BPJS*/
									   THEN 1/*Billing Tagihan RaJal*/
								  WHEN b.idJenisPerawatan = 2/*Rawat Jalan*/ And b.idJenisPendaftaran = 1/*IGD*/ AND c.idJenisPenjaminInduk = 2/*BPJS*/
									   THEN 5/*Billing Tagihan Igd*/
								  ELSE 6/*Billing Tagihan RaNap*/
							  END
	  FROM dbo.transaksiOrder a
		   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
		   OUTER APPLY dbo.getInfo_penjamin(b.idJenisPenjaminPembayaranPasien) c
	 WHERE a.idOrder = @idOrder;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Declare @tablePemeriksaan Table(idMasterTarif int, idMasterTarifHeader int);

	INSERT INTO @tablePemeriksaan
			   (idMasterTarif
			   ,idMasterTarifHeader)
		 SELECT DISTINCT value
			   ,b.idMasterTarifHeader
		   FROM String_Split(@listPemeriksaan, '|') a
				Inner Join dbo.masterTarip b On a.value = b.idMasterTarif
		  WHERE Trim(value) <> '';

	Begin Try
		/*Transaction Begin*/
		Begin Tran;

		/*INSERT Data Order Detail*/
		INSERT INTO [dbo].[transaksiOrderDetail]
				   ([idOrder]
				   ,[idMasterTarif]
				   ,[idUserEntry])
			 SELECT @idOrder
				   ,a.idMasterTarif
				   ,@idUserEntry
			   FROM @tablePemeriksaan a
					OUTER APPLY (SELECT xa.idOrderDetail
								   FROM dbo.transaksiOrderDetail xa
										INNER JOIN dbo.masterTarip xb ON xa.idMasterTarif = xb.idMasterTarif
								  WHERE xb.idMasterTarifHeader = a.idMasterTarifHeader AND xa.idOrder = @idOrder) b
			  WHERE b.idOrderDetail Is Null;

		/*Add Data Tindakan*/
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
					Inner Join dbo.masterTaripDetail b On a.idMasterTarif = b.idMasterTarip And b.[status] = 1
					Inner Join dbo.transaksiOrderDetail c On a.idOrderDetail = c.idOrderDetail
					Left join dbo.transaksiTindakanPasienDetail d On a.idTindakanPasien = d.idTindakanPasien
			  WHERE c.idOrder = @idOrder And d.idTindakanPasienDetail Is Null;

		/*Transaction Commit*/
		Commit Tran;
		Select 'Data Pemeriksaan Radiologi Berhasil Disimpan' As respon, 1 As responCode;
	End Try
	Begin Catch
		/*Transaction Rollback*/
		Rollback Tran;
		Select 'Error!: '+ ERROR_MESSAGE() As respon, NULL As responCode;
	End Catch
END