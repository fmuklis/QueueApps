-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterTaripInsert]
	-- Add the parameters for the stored procedure here
	@idMasterPelayanan int
	,@idMasterTarifHeader int
	,@idKelas int
	,@idJenisTarif int
	,@idSatuanTarif int
	,@idMasterKatagoriTarip int
	,@tarip money
	,@BHP bit

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idMasterTarif int;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*UPDATE Tarif Header*/
	If Not Exists(Select 1 From dbo.masterTarifHeader Where idMasterTarifHeader = @idMasterTarifHeader And BHP = @BHP)
		Begin
			UPDATE dbo.masterTarifHeader 
			   SET BHP = @BHP
			 WHERE idMasterTarifHeader = @idMasterTarifHeader;
		End

	/*INSERT Master Tarif*/
	If Not Exists(Select 1 From dbo.masterTarip Where idMasterTarifHeader = @idMasterTarifHeader And idKelas = @idKelas And idMasterPelayanan = @idMasterPelayanan)
		Begin
			INSERT INTO [dbo].[masterTarip]
					   ([idMasterTarifHeader]
					   ,[idMasterPelayanan]
					   ,[idKelas]
					   ,[idJenisTarif]
					   ,[idSatuanTarif])
				 VALUES
					   (@idMasterTarifHeader
					   ,@idMasterPelayanan
					   ,@idKelas
					   ,@idJenisTarif
					   ,@idSatuanTarif)
		End

	/*GET idMasterTarif*/
	Select @idMasterTarif = idMasterTarif From dbo.masterTarip Where idMasterTarifHeader = @idMasterTarifHeader And idKelas = @idKelas;
	
	/*INSERT Master Tarif Detail*/
	If Not Exists(Select 1 From dbo.masterTaripDetail Where idMasterTarip = @idMasterTarif And idMasterKatagoriTarip = @idMasterKatagoriTarip)
		Begin
			INSERT INTO [dbo].[masterTaripDetail]
				   ([idMasterTarip]
				   ,[idMasterKatagoriTarip]
				   ,[tarip]
				   ,[status])
			 VALUES
				   (@idMasterTarif
				   ,@idMasterKatagoriTarip
				   ,@tarip
				   ,1/*Aktif*/);

			Select 'Tarif Berhasil Disimpan' As respon, 1 As responCode;
		End
	Else
		Begin
			Select 'Gagal!: Data Tarif Sudah Ada' As respon, 0 As responCode;
		End
END