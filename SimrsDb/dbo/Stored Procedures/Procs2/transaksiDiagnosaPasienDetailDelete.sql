-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiDiagnosaPasienDetailDelete]
	-- Add the parameters for the stored procedure here
	@idDiagnosaDetail int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Delete from transaksiDiagnosaPasienDetail where idDiagnosaDetail = @idDiagnosaDetail;
	select 'Data Berhasil Dihapus' as respon,1 as responCode;
END