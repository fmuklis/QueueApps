-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Muklis F>
-- Create date: <Create 20,07,2018>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterRuanganTempatTidurInsert] 
	-- Add the parameters for the stored procedure here
	@idRuanganRawatInap int,
	@noTempatTidur int,
	@keteranganTempatTidur nvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	If Not Exists(Select 1 From dbo.masterRuanganTempatTidur Where idRuanganRawatInap = @idRuanganRawatInap And noTempatTidur = @noTempatTidur)
		Begin
			INSERT INTO [dbo].[masterRuanganTempatTidur]
					   ([idRuanganRawatInap]
					   ,[noTempatTidur]
					   ,[flagMasihDigunakan]
					   ,[keteranganTempatTidur])
				 VALUES
					   (@idRuanganRawatInap
					   ,@noTempatTidur 
					   ,1
					   ,@keteranganTempatTidur);

				Select 'Data Bed Berhasil Disimpan' AS respon, 1 AS responCode;
			End
		ELSE
			Begin
				Select 'Data Bed Nomor '+ CAST(@noTempatTidur AS varchar(50)) +' Sudah Terdaftar' AS respon, 0 AS responCode;
			End
END