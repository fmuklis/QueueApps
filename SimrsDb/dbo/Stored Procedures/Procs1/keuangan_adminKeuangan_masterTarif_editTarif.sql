-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[keuangan_adminKeuangan_masterTarif_editTarif]
	-- Add the parameters for the stored procedure here
	@idMasterTarif int,
	@idKelas int,
	@idJenisTarif int,
	@idSatuanTarif int,
	@listTarif nvarchar(250),
	@BHP bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Declare @idMasterTarifHeader int
		   ,@idMasterPelayanan int;
	 Select @idMasterTarifHeader = idMasterTarifHeader, @idMasterPelayanan = idMasterPelayanan
	   From dbo.masterTarip Where idMasterTarif = @idMasterTarif;

	Declare @tableListTarif table(idMasterKatagoriTarip int, tarif money);
	
	INSERT INTO @tableListTarif
			   (idMasterKatagoriTarip
			   ,tarif)
		 SELECT Cast(Left(value, CharIndex(CHAR(9), value)-1) As int)
			   ,Cast(Right(value, CharIndex(CHAR(9), reverse(value))-1) As money)
		   FROM STRING_SPLIT(@listTarif, '|') a
		  WHERE Trim(value) <> '';

    -- Insert statements for procedure here
	If Exists(Select Top 1 1 From dbo.masterTarip Where idMasterTarif <> @idMasterTarif And idMasterTarifHeader = @idMasterTarifHeader And idKelas = @idKelas And idMasterPelayanan = @idMasterPelayanan)
		Begin
			Select 'Sudah Ada Tarif Yang Sama' As respon, 0 As responCode;
		End
	Else
		Begin Try
			/*Transaction Begin*/
			Begin Tran;

			/*UPDATE Data Tarif*/
			UPDATE [dbo].[masterTarip]
			   SET [idKelas] = @idKelas
				  ,[idJenisTarif] = @idJenisTarif
				  ,[idSatuanTarif] = @idSatuanTarif
			 WHERE idMasterTarif = @idMasterTarif;

			/*UPDATE BHP Tarif*/
			UPDATE a
			   SET a.BHP = @BHP
			  FROM dbo.masterTarifHeader a
				   Inner Join dbo.masterTarip b On a.idMasterTarifHeader = b.idMasterTarifHeader
			 WHERE b.idMasterTarif = @idMasterTarif;

			/*UPDATE Menonaktifkan Tarif*/
			UPDATE dbo.masterTaripDetail
			   SET [status] = 0/*Tidak Aktif*/
				  ,[tglNonAktif] = getDate()
			 WHERE idMasterTarip = @idMasterTarif;

			/*Entry Data Tarif Baru*/
			INSERT INTO [dbo].[masterTaripDetail]
					   ([idMasterTarip]
					   ,[idMasterKatagoriTarip]
					   ,[tarip])
				 SELECT @idMasterTarif
					   ,idMasterKatagoriTarip
					   ,tarif
				   FROM @tableListTarif

			/*Transaction Commit*/
			Commit Tran;
			
			/*Respon*/
			Select 'Tarif Berhasil Diupdate' As respon, 1 As responCode;
		End Try
		Begin Catch
			/*Transaction Rollback*/
			Rollback Tran;

			/*Respon*/
			Select 'Error!: '+ ERROR_MESSAGE() As respon, NULL As responCode;
		End Catch
END