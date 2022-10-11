-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiStokOpnameSelect]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*SELECT [idStokOpname]
		  ,b.[tahun] ,b.[bulan]
		  ,c.idObat ,c.[namaObat]
		  ,[jumlahStokOpname]
		  ,a.[hargaPokok]
		  ,a.[hargaJual]
		  ,d.idPetugasFarmasi ,d.[namaPetugasFarmasi]
		  ,a.[tglStokOpname]
		  ,a.[tglEntry]
		  ,a.[idUserEntry]
	  FROM [dbo].[farmasiStokOpname] a 
		   Inner Join [dbo].[farmasiStokOpnamePeriode] b On a.[idPeriodeStokOpname] = b.[idPeriodeStokOpname]
		   Inner Join [dbo].[farmasiMasterObat] c On a.[idObat] = c.[idObat]
		   Inner Join [dbo].[farmasiMasterPetugas] d On a.[idPetugas] = d.[idPetugasFarmasi]*/
END