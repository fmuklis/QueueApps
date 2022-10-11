-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[laboratorium_pemeriksaan_entryTindakan_pemeriksaanAddPasienLuar]
	-- Add the parameters for the stored procedure here
	@idOrder bigint,
	@listPemeriksaan nvarchar(250),
	@idUserEntry int,
	@tglTindakan date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idTindakanPasien bigint;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Declare @tablePemeriksaan Table(idMasterTarif int, idMasterTarifHeader int);

	INSERT INTO @tablePemeriksaan
			   (idMasterTarif
			   ,idMasterTarifHeader)
		 SELECT Distinct value
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
					Left Join dbo.transaksiOrderDetail b On a.idMasterTarif = b.idMasterTarif And b.idOrder = @idOrder
						Left Join dbo.masterTarip ba On a.idMasterTarifHeader = ba.idMasterTarifHeader And b.idMasterTarif = ba.idMasterTarif
			  WHERE ba.idMasterTarif Is Null;

		/*INSERT Data Tindakan*/
		INSERT INTO [dbo].[transaksiTindakanPasien]
				   ([idOrderDetail]
				   ,[idJenisBilling]
				   ,[idRuangan]
				   ,[idMasterTarif]
				   ,[tglTindakan]
				   ,[idUserEntry])
			 SELECT b.idOrderDetail
				   ,2/*Billing Laboratorium*/
				   ,a.idRuanganTujuan
				   ,b.idMasterTarif
				   ,@tglTindakan
				   ,@idUserEntry
			   FROM dbo.transaksiOrder a
					Inner Join dbo.transaksiOrderDetail b On a.idOrder = b.idOrder
						Left Join dbo.transaksiTindakanPasien ba On b.idOrderDetail = ba.idOrderDetail
			  WHERE a.idOrder = @idOrder And ba.idTindakanPasien Is Null;

		/*INSERT Data Tindakan Detail*/
		INSERT INTO [dbo].[transaksiTindakanPasienDetail]
				   ([idTindakanPasien]
				   ,[idMasterKatagoriTarip]
				   ,[nilai])
			 SELECT a.idTindakanPasien
				   ,b.idMasterKatagoriTarip
				   ,b.tarip
			   FROM dbo.transaksiTindakanPasien a
					Inner Join dbo.masterTaripDetail b On a.idMasterTarif = b.idMasterTarip And b.status = 1
					Inner Join dbo.transaksiOrderDetail c On a.idOrderDetail = c.idOrderDetail
					Left join dbo.transaksiTindakanPasienDetail d On a.idTindakanPasien = d.idTindakanPasien
			  WHERE c.idOrder = @idOrder And d.idTindakanPasienDetail Is Null;

		/*Transaction Commit*/
		Commit Tran;
		Select 'Data Pemeriksaan Laboratorium Berhasil Disimpan' As respon, 1 As responCode;
	End Try
	Begin Catch
		/*Transaction Rollback*/
		Rollback Tran;
		Select 'Error!: '+ ERROR_MESSAGE() As respon, NULL As responCode;
	End Catch
END