-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laboratorium_pemeriksaan_hasilPemeriksaanLaboratorium_listPetugasOtorisasi_luar]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT idUser AS idOtorisator, namaLengkap AS otorisator
	  FROM dbo.masterUser
	 WHERE idGroupUser = 14/*Petugas Laboratorium*/
  ORDER BY namaLengkap
END