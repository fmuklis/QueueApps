-- =============================================
-- Author:		takin788
-- Create date: 21-12-2021
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE api_wsdl_alamat_video
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select * from antreanAlamatVideo
	--select count(idVideo) as  from antreanAlamatVideo
END