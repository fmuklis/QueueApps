-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRajal_editProvinsi]
	-- Add the parameters for the stored procedure here
	 @idProvinsi int
	,@namaProvinsi nvarchar(50)
	,@idNegara int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (SELECT 1 from [dbo].[masterProvinsi] where [idProvinsi] = @idProvinsi)
		BEGIN
			UPDATE [dbo].[masterProvinsi]
			SET  [namaProvinsi] = @namaProvinsi
				,[idNegara] = @idNegara
			WHERE [idProvinsi] = @idProvinsi;
			SELECT 'Data Berhasil Diubah' as respon, 1 as responCode;
		END
	ELSE
		BEGIN
			SELECT 'Maaf Data Tidak Ditemukan' as respon, 0 as responCode;
		END
END