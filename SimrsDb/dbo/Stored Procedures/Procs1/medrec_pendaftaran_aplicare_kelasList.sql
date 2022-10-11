-- =============================================
-- Author:		Komar
-- Create date: 29/11/2021
-- Description:	master kelas untuk aplicare
-- =============================================
CREATE PROCEDURE medrec_pendaftaran_aplicare_kelasList
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.kodeKelas, a.namaKelas 
	  FROM dbo.masterKelas a 
	 WHERE a.kodeKelas <> '0'
END