-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasiStokOpnameUpdate]
	-- Add the parameters for the stored procedure here
	@idStokOpname int
	,@jumlahStokOpname decimal
	,@hargaPokok money
	,@hargaJual money
	,@idPetugas int
	,@tglStokOpname date
	,@idUserEntry int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*If Exists (Select 1 From farmasiStokOpname Where idStokOpname = @idStokOpname)
		Begin
			UPDATE [dbo].[farmasiStokOpname]
			   SET [jumlahStokOpname] = @jumlahStokOpname
				  ,[hargaPokok] = @hargaPokok
				  ,[hargaJual] = @hargaJual
				  ,[idPetugas] = @idPetugas
				  ,[tglStokOpname] = @tglStokOpname
				  ,[tglEntry] = GETDATE()
				  ,[idUserEntry] = @idUserEntry
			 WHERE idStokOpname = @idStokOpname;
			Select 'Data Berhasil Diupdate' as respon, 1 as responCode;
		End
	Else
		Begin
			Select 'Data Tidak Ditemukan' as respon, 0 as responCode;
		End*/
END