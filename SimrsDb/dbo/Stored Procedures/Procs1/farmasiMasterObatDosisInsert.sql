-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiMasterObatDosisInsert]
	-- Add the parameters for the stored procedure here
	@idObat int
    ,@idSatuanDosis int
    ,@dosis decimal(18,2)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	If Not Exists(Select 1 From [dbo].[farmasiMasterObatDosis] a Where a.idObat = @idObat And dosis = @dosis And idSatuanDosis = @idSatuanDosis)
		Begin
			INSERT INTO [dbo].[farmasiMasterObatDosis]
				   ([idObat]
				   ,[idSatuanDosis]
				   ,[dosis]
				   ,[hargaJual])
			 VALUES
				   (@idObat
				   ,@idSatuanDosis
				   ,@dosis
				   ,0);
			Select 'Data Barang Farmasi Berhasil Ditambah' As respon, 1 As responCode;
		End
	Else
		Begin
			Select 'Gagal!: Sudah Ada Data Yang Sama' As respon, 0 As responCode;
		End
END