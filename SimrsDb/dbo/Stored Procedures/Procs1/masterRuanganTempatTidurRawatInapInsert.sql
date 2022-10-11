-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Muklis F>
-- Create date: <Create 20,07,2018>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterRuanganTempatTidurRawatInapInsert] 
	-- Add the parameters for the stored procedure here
	@idRuanganRawatInap int
   ,@noTempatTidur int
   ,@kapasitas int
   ,@keteranganTempatTidur nvarchar(max)
   ,@flagMasihDigunakan bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

		IF not exists (select 1 from [masterRuanganTempatTidur] where idRuanganRawatInap = @idRuanganRawatInap and noTempatTidur = @noTempatTidur)
			Begin
				INSERT INTO [dbo].[masterRuanganTempatTidur]
						   ([idRuanganRawatInap]
						   ,[noTempatTidur]
						   ,[kapasitas]
						   ,[flagMasihDigunakan]
						   ,[keteranganTempatTidur])
					 VALUES
						   (
							@idRuanganRawatInap
						   ,@noTempatTidur
						   ,@kapasitas
						   ,@keteranganTempatTidur
						   ,@flagMasihDigunakan);
				SELECT 'Data Berhasil Disimpan' as respon, 1 as responCode;
			End
		ELSE
			Begin
				SELECT 'Maaf Data Sudah Ada' as respon, 0 as responCode;
			End

END