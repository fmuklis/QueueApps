-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterSatuanObatUpdate] 
	-- Add the parameters for the stored procedure here
	@idSatuanObat int
	,@namaSatuanObat nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.farmasiMasterSatuanObat Where namaSatuanObat = @namaSatuanObat And idSatuanObat <> @idSatuanObat)
		Begin
			/*Respon*/
			Select 'Tidak Dapat Disimpan, Sudah Ada Data Yang Sama' As respon, 0 As responCode;
		End
	Else
		Begin
			UPDATE [dbo].[farmasiMasterSatuanObat]
			   SET [namaSatuanObat] = @namaSatuanObat
			 WHERE idSatuanObat = @idSatuanObat;

			/*Respon*/
			Select 'Data Berhasil Diupdate' As respon, 1 As responCode;
		End
END