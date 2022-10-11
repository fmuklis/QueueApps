-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		Start-X
-- Create date: 15-10-2018
-- Description:	Update To masterTarif & masterTarifDetil
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterTarif_Update]
	-- Add the parameters for the stored procedure here
	-- Master Tarif
	 @idMasterTarif int
	,@namaTarif nvarchar(250)
    ,@idMasterPelayanan int
    ,@idKelas int
    ,@idJenisTarif int
    ,@idSatuanTarif int
	,@Keterangan nvarchar(max)
	--Master Tarif Detil
	,@idMasterKatagoriTarip int
	,@tarip money
	,@idPeriodeTarip int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idMasterTarifTmp int;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF @idMasterTarif = 0
		Begin
			IF Not Exists(Select 1 From dbo.masterTarip Where namaTarif = @namaTarif And idKelas = @idKelas)
				Begin
					INSERT INTO [dbo].[masterTarip]
							   ([idPeriodeTarip]
							   ,[namaTarif]
							   ,[idMasterPelayanan]
							   ,[idKelas]
							   ,[idJenisTarif]
							   ,[idSatuanTarif]
							   ,[Keterangan])
						 VALUES
							   (@idPeriodeTarip
							   ,@namaTarif
							   ,@idMasterPelayanan
							   ,@idKelas
							   ,@idJenisTarif
							   ,@idSatuanTarif
							   ,@Keterangan);

					INSERT INTO [dbo].[masterTaripDetail]
							   ([idMasterTarip]
							   ,[idMasterKatagoriTarip]
							   ,[tarip])
						 VALUES
							   (SCOPE_IDENTITY()
							   ,@idMasterKatagoriTarip
							   ,@tarip);	
							   					
				End
			Else
				Begin
					Select @idMasterTarifTmp = idMasterTarif From dbo.masterTarip Where namaTarif = @namaTarif And idKelas = @idKelas;

					INSERT INTO [dbo].[masterTaripDetail]
							   ([idMasterTarip]
							   ,[idMasterKatagoriTarip]
							   ,[tarip])
						 VALUES
							   (@idMasterTarifTmp
							   ,@idMasterKatagoriTarip
							   ,@tarip);
				End
			Select 'Data Berhasil Diupdate' as respon, 1 as responCode;
		End
	ELSE IF EXISTS(SELECT 1 from [dbo].[masterTarip] where idMasterTarif = @idMasterTarif)
		Begin Try
			Begin Tran masterTarif_Update_Monggo;
			UPDATE [dbo].[masterTarip]
			   SET	 [namaTarif] = @namaTarif
					,[idMasterPelayanan] = @idMasterPelayanan
					,[idKelas] = @idKelas
					,[idJenisTarif] = @idJenisTarif
					,[idSatuanTarif] = @idSatuanTarif
					,[Keterangan] = @Keterangan
			 WHERE idMasterTarif = @idMasterTarif;

			If Exists(Select 1 From dbo.masterTaripDetail Where idMasterTarip = @idMasterTarif And idMasterKatagoriTarip = @idMasterKatagoriTarip)
				Begin
					Update dbo.masterTaripDetail
					   Set tarip = @tarip
					 Where idMasterTarip = @idMasterTarif And idMasterKatagoriTarip = @idMasterKatagoriTarip;
				End	
			Else
				Begin
					Insert Into dbo.masterTaripDetail
								([idMasterTarip]
								,[idMasterKatagoriTarip]
								,[tarip])
						 Values (@idMasterTarif
								,@idMasterKatagoriTarip
								,@tarip);
				End					
						
			Commit Tran masterTarif_Update_Monggo;	
			Select 'Data Berhasil Diupdate' as respon, 1 as responCode;
		End	Try
		Begin Catch
			Rollback Tran masterTarif_Update_Monggo;	
			Select 'Error !:' + ERROR_MESSAGE() As respon, 0 As responCode; 
		End Catch	
	Else
		Begin
			Select 'Data Tidak Ditemukan' as respon, 0 as responCode;
		End
END