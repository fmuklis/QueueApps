-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterObatSatuanDosisInsert] 
	-- Add the parameters for the stored procedure here
	@namaSatuanDosis nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.farmasiMasterObatSatuanDosis Where namaSatuanDosis = @namaSatuanDosis)
		Begin
			INSERT INTO [dbo].[farmasiMasterObatSatuanDosis]
					   ([namaSatuanDosis])
				 VALUES
					   (@namaSatuanDosis);
			Select 'Data Berhasil Disimpan' As respon, 1 As responCode;
		End
	Else
		Begin
			Select 'Gagal!: Data '+ @namaSatuanDosis +' Sudah Ada' As respon, 0 As responCode;
		End
END