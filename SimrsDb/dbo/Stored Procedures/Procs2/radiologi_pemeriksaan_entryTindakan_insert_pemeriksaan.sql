-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[radiologi_pemeriksaan_entryTindakan_insert_pemeriksaan]
	-- Add the parameters for the stored procedure here
	@idOrderDetail bigint,
	@tglTindakan datetime,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idJenisBilling Int
		   ,@idOrder bigint
		   ,@idMasterTarifHeader int;

	SELECT @idJenisBilling = CASE
								  WHEN ba.idJenisPerawatan = 2/*RaJal*/ AND ba.idJenisPendaftaran IN(1,2) AND bb.idJenisPenjaminInduk = 1/*UMUM*/
									   THEN 4/*Billing Tagihan Radiologi*/
								  WHEN ba.idJenisPerawatan = 2/*Rawat Jalan*/ And ba.idJenisPendaftaran = 2/*Poli RaJal*/ AND bb.idJenisPenjaminInduk = 2/*BPJS*/
									   THEN 1/*Billing Tagihan RaJal*/
								  WHEN ba.idJenisPerawatan = 2/*Rawat Jalan*/ And ba.idJenisPendaftaran = 1/*IGD*/ AND bb.idJenisPenjaminInduk = 2/*BPJS*/
									   THEN 5/*Billing Tagihan Igd*/
								  ELSE 6/*Billing Tagihan RaNap*/
							  END
		  ,@idOrder = a.idOrder
		  ,@idMasterTarifHeader = c.idMasterTarifHeader
	  From dbo.transaksiOrderDetail a
		   Inner Join dbo.transaksiOrder b On a.idOrder = b.idOrder
	  		   Inner Join dbo.transaksiPendaftaranPasien ba On b.idPendaftaranPasien = ba.idPendaftaranPasien
			   OUTER APPLY dbo.getInfo_penjamin(ba.idJenisPenjaminPembayaranPasien) bb
		   Inner Join dbo.masterTarip c On a.idMasterTarif = c.idMasterTarif
	 Where a.idOrderDetail = @idOrderDetail;

	SET NOCOUNT ON;

    -- Insert statements for procedure here

	If Exists(Select Top 1 1 
				From dbo.transaksiTindakanPasien a
				     Inner Join dbo.transaksiOrderDetail b On a.idOrderDetail = b.idOrderDetail
					 Inner Join dbo.masterTarip c On a.idMasterTarif = c.idMasterTarif
				Where b.idOrder = @idOrder And c.idMasterTarifHeader = @idMasterTarifHeader)
		Begin
			Select 'Sudah Ada Pemeriksaan '+ a.namaTarifHeader +' Pada Pasien Ini' As respon, 0 As responCode
			  From dbo.masterTarifHeader a
			 Where a.idMasterTarifHeader = @idMasterTarifHeader;
		End
	Else
		Begin
			INSERT INTO [dbo].[transaksiTindakanPasien]
					   ([idPendaftaranPasien]
					   ,[idOrderDetail]
					   ,[idJenisBilling]
					   ,[idRuangan]
					   ,[idMasterTarif]
					   ,[tglTindakan]
					   ,[idUserEntry]
					   ,[TglEntry])
				 SELECT a.idPendaftaranPasien
					   ,b.idOrderDetail
					   ,@idJenisBilling
					   ,a.idRuanganTujuan
					   ,b.idMasterTarif
					   ,@tglTindakan
					   ,@idUserEntry
					   ,GetDate()
				   FROM dbo.transaksiOrder a
						Inner Join dbo.transaksiOrderDetail b On a.idOrder = b.idOrder
				  WHERE b.idOrderDetail = @idOrderDetail;

			INSERT INTO [dbo].[transaksiTindakanPasienDetail]
					   ([idTindakanPasien]
					   ,[idMasterKatagoriTarip]
					   ,[nilai])
				 SELECT a.idTindakanPasien
					   ,b.idMasterKatagoriTarip
					   ,b.tarip
				   FROM dbo.transaksiTindakanPasien a
						Inner Join dbo.masterTaripDetail b On a.idMasterTarif = b.idMasterTarip
				  WHERE a.idOrderDetail = @idOrderDetail And b.[status] = 1;

			Select 'Data Pemeriksaan Raadiologi Berhasil Disimpan' As respon, 1 As responCode;
		End
END