-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[keuangan_adminKeuangan_masterTarif_addTarifHeader]
	-- Add the parameters for the stored procedure here
	@idMasterTarifGroup int,
	@namaTarifHeader nvarchar(225)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.masterTarifHeader Where namaTarifHeader = @namaTarifHeader)
		Begin
			INSERT INTO [dbo].[masterTarifHeader]
					   ([idMasterTarifGroup]
					   ,[namaTarifHeader])
				 VALUES
					   (@idMasterTarifGroup
					   ,@namaTarifHeader);

			Select 'Nama Tarif Berhasil Disimpan' As respon, 1 As responCode;
		End
	Else
		Begin
			Select 'Gagal!: Sudah Ada Nama Tarif Yang Sama' As respon, 0 As responCode;
		End
END