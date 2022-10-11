-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterRuanganTempatTidurSelectByidTempatTidur] 
	-- Add the parameters for the stored procedure here
	@idTempatTidur int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select a.idTempatTidur, ba.namaRuangan As namaGedung, ba.Alias, b.namaRuanganRawatInap, a.kapasitas, c.idKelas, c.namaKelas As namaKelasRuangan
		  ,a.noTempatTidur, a.flagMasihDigunakan, a.keteranganTempatTidur
	  From dbo.masterRuanganTempatTidur a 
		   Inner Join dbo.masterRuanganRawatInap b On a.idRuanganRawatInap = b.idRuanganRawatInap
				Inner Join dbo.masterRuangan ba On b.idRuangan = ba.idRuangan 
		   Inner Join dbo.masterKelas c on b.idKelas = c.idKelas
	 Where a.idTempatTidur = @idTempatTidur
END