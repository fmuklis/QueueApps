-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterTaripUpdate]
	-- Add the parameters for the stored procedure here
	@idMasterTarif int
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
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.masterTarip Where idMasterTarif = @idMasterTarif)
		Begin
			Select 'Data Tidak Ditemukan' As respon, 0 As responCode;
		End
	Else
		Begin
			UPDATE [dbo].[masterTarip]
			   SET [idKelas] = @idKelas
				  ,[idJenisTarif] = @idJenisTarif
				  ,[idSatuanTarif] = @idSatuanTarif
			 WHERE idMasterTarif = @idMasterTarif;

			UPDATE a
			   SET a.BHP = @BHP
			  FROM dbo.masterTarifHeader a
				   Inner Join dbo.masterTarip b On a.idMasterTarifHeader = b.idMasterTarifHeader
			 WHERE b.idMasterTarif = @idMasterTarif;

			If @idMasterKatagoriTarip <> 0
				Begin
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
						End
					Else If IsNull(@tarip, 0) = 0 And Exists(Select 1 From dbo.masterTaripDetail Where idMasterTarip = @idMasterTarif And idMasterKatagoriTarip = @idMasterKatagoriTarip)
						Begin
							UPDATE dbo.masterTaripDetail
							   SET [status] = 0/*Tidak Aktif*/
							 WHERE idMasterTarip = @idMasterTarif And idMasterKatagoriTarip = @idMasterKatagoriTarip
						End
					Else
						Begin
							UPDATE dbo.masterTaripDetail
							   SET [status] = 0/*Tidak Aktif*/
							 WHERE idMasterTarip = @idMasterTarif And idMasterKatagoriTarip = @idMasterKatagoriTarip;

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
						End
				End
			Select 'Tarif Berhasil Diupdate' As respon, 1 As responCode;
		End
END