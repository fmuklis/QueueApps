-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[keuangan_adminKeuangan_masterTarif_addTarif]
	-- Add the parameters for the stored procedure here
	@idMasterPelayanan int,
	@idMasterTarifHeader int,
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
	Declare @idMasterTarif int;
	Declare @tableListTarif table(idMasterKatagoriTarip int, tarif money);
	
	INSERT INTO @tableListTarif
			   (idMasterKatagoriTarip
			   ,tarif)
		 SELECT Cast(Left(value, CharIndex(CHAR(9), value)-1) As int)
			   ,Cast(Right(value, CharIndex(CHAR(9), reverse(value))-1) As money)
		   FROM STRING_SPLIT(@listTarif, '|') a
		  WHERE Trim(value) <> '';

    -- Insert statements for procedure here

	/*UPDATE Tarif Header*/
	If Not Exists(Select 1 From dbo.masterTarifHeader Where idMasterTarifHeader = @idMasterTarifHeader And BHP = @BHP)
		Begin
			UPDATE dbo.masterTarifHeader 
			   SET BHP = @BHP
			 WHERE idMasterTarifHeader = @idMasterTarifHeader;
		End

	If Exists(Select 1 From dbo.masterTarip Where idMasterTarifHeader = @idMasterTarifHeader And idKelas = @idKelas And idMasterPelayanan = @idMasterPelayanan)
		Begin
			Select 'Gagal!: Data Tarif Sudah Ada' As respon, 0 As responCode;
		End
	Else
		Begin
			/*INSERT Master Tarif*/
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

			/*GET idMasterTarif*/
			Select @idMasterTarif = idMasterTarif From dbo.masterTarip Where idMasterTarifHeader = @idMasterTarifHeader And idKelas = @idKelas;
	
			/*INSERT Master Tarif Detail*/
			INSERT INTO [dbo].[masterTaripDetail]
					   ([idMasterTarip]
					   ,[idMasterKatagoriTarip]
					   ,[tarip])
				 SELECT @idMasterTarif
					   ,idMasterKatagoriTarip
					   ,tarif
				   FROM @tableListTarif

			Select 'Tarif Berhasil Disimpan' As respon, 1 As responCode;
		End
END