-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterObatDosisUpdate] 
	-- Add the parameters for the stored procedure here
	@idObatDosis int
	,@idSatuanDosis int
	,@dosis decimal(18,2)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.farmasiMasterObatDosis Where idObatDosis = @idObatDosis)
		Begin
			Select 'Data Tidak Ditemukan' As respon, 0 As responCode;
		End
	Else
		Begin
			UPDATE [dbo].[farmasiMasterObatDosis]
			   SET [idSatuanDosis] = @idSatuanDosis
				  ,[dosis] = @dosis
			 WHERE idObatDosis = @idObatDosis;
			 Select 'Data Barang Farmasi Berhasil Diupdate' As respon, 1 As responCode;
		End
END