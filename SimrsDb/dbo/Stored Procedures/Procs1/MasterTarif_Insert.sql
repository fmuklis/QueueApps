-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		Start-X
-- Create date: 12-10-2018
-- Description:	Insert To masterTarif & masterTarifDetil
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[MasterTarif_Insert] 
	-- Add the parameters for the stored procedure here

	-- Master Tarif
	@namaTarif nvarchar(50)
    ,@idMasterPelayanan int
    ,@idKelas int
    ,@idJenisTarif int
    ,@idSatuanTarif int
	--Master Tarif Detil
	,@idMasterKatagoriTarip int
	,@tarip money
	,@Keterangan nvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idMasterTarif int
			,@idMasterTarifHeader int;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists (Select 1 From masterTarifHeader Where namaTarifHeader = @namaTarif)
		Begin
			INSERT INTO [dbo].[masterTarifHeader]
					   ([namaTarifHeader]
					   ,keterangan)
				VALUES (UPPER(@namaTarif)
					   ,@Keterangan);		 
		End

	Select @idMasterTarifHeader = idMasterTarifHeader From dbo.masterTarifHeader Where namaTarifHeader = @namaTarif;

	If Not Exists ( Select 1 From masterTarip Where idMasterPelayanan = @idMasterPelayanan And idMasterTarifHeader = @idMasterTarifHeader And idKelas = @idKelas)
		Begin
			INSERT INTO [dbo].[masterTarip]
					   (idMasterTarifHeader
					   ,[idMasterPelayanan]
					   ,[idKelas]
					   ,[idJenisTarif]
					   ,[idSatuanTarif]
					   ,Keterangan)
				VALUES (@idMasterTarifHeader
					   ,@idMasterPelayanan 
					   ,@idKelas
					   ,@idJenisTarif
					   ,@idSatuanTarif
					   ,@Keterangan);
		End

	Select @idMasterTarif = idMasterTarif From dbo.masterTarip Where idMasterPelayanan = @idMasterPelayanan And idMasterTarifHeader = @idMasterTarifHeader And idKelas = @idKelas;
		
	If Not Exists ( Select 1 From dbo.masterTaripDetail Where idMasterTarip = @idMasterTarif And idMasterKatagoriTarip = @idMasterKatagoriTarip)  		
		Begin	
			INSERT INTO [dbo].[masterTaripDetail]
					   ([idMasterTarip]
					   ,[idMasterKatagoriTarip]
					   ,[tarip])
				 VALUES (@idMasterTarif
					   ,@idMasterKatagoriTarip
					   ,@tarip);
			SELECT 'Data Berhasil Disimpan' respon, 1 responCode;
		End
	ELSE
		Begin
			SELECT 'Data Sudah Ada' respon, 0 responCode;
		End 
END