
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterRuangan_SelectByKelas] 
	-- Add the parameters for the stored procedure here
	@idKelasRuangan int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT   idRuanganRawatInap
			,namaRuanganRawatInap
			from masterRuanganRawatInap
			where idKelas = @idKelasRuangan
		order by [namaRuanganRawatInap] asc
END