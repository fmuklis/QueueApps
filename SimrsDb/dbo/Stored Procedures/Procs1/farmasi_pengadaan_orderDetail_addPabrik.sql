-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE farmasi_pengadaan_orderDetail_addPabrik
	-- Add the parameters for the stored procedure here
	@namaPabrik varchar(250),
	@alamatPabrik varchar(max),
	@telp varchar(50)
	 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.farmasiMasterPabrik Where namaPabrik = @namaPabrik)
		Begin
			Select 'Principal '+ @namaPabrik +' Telah Terdaftar' AS respon, 0 AS responCode; 
		End
	Else
		Begin
			INSERT INTO [dbo].[farmasiMasterPabrik]
					   ([namaPabrik]
					   ,[alamatPabrik]
					   ,[telp])
				 VALUES
					   (@namaPabrik
					   ,@alamatPabrik
					   ,@telp);

			Select 'Data Principal Berhasil Disimpan' AS respon, 1 AS responCode; 
		End
END