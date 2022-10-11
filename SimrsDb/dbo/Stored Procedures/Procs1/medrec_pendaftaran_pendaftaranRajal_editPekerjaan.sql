-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_editPekerjaan]
	-- Add the parameters for the stored procedure here
	 @idPekerjaan int
	,@namaPekerjaan nvarchar(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (select 1 from [dbo].[masterPekerjaan] where [namaPekerjaan] = @namaPekerjaan AND [idPekerjaan] <> @idPekerjaan)
		BEGIN
				SELECT 'Pekerjaan '+ @namaPekerjaan +' telah terdaftar' as respon, 0 as responCode;
		END
	ELSE
		BEGIN
			UPDATE [dbo].[masterPekerjaan]
			SET  [namaPekerjaan] = @namaPekerjaan
			WHERE [idPekerjaan] = @idPekerjaan;
			SELECT 'Data berhasil diupdate' as respon, 1 as responCode;
		END
	
END