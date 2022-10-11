-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienSelectByidRuangan]
	-- Add the parameters for the stored procedure here
	@idRuangan int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare  @FlagPoli bit = 0;
		If Exists(Select 1 From [dbo].[masterRuangan] Where [idRuangan] = @idRuangan And idJenisRuangan In (1,2,3))
			Begin
				Set @FlagPoli = 1
			End

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [idPendaftaranPasien],b.kodePasien
	-- PASIEN --  
		  ,Substring(b.[kodePasien],1,2)+'.'+Substring(b.[kodePasien],3,2)+'.'+Substring(b.[kodePasien],5,2) as noRM
		  ,Case 
			  when b.idJenisKelaminPasien = 2 and idStatusPerkawinanPasien in (2,3) then  b.namaLengkapPasien + '. NY BINTI ' + b.namaAyahPasien
			  when b.idJenisKelaminPasien = 2 and idStatusPerkawinanPasien in (1) and DATEDIFF(hour,tglLahirPasien,GETDATE())/8766>16 then  b.namaLengkapPasien + '. NN BINTI ' + b.namaAyahPasien
			  when b.idJenisKelaminPasien = 2 and idStatusPerkawinanPasien in (1) and DATEDIFF(hour,tglLahirPasien,GETDATE())/8766< = 16 then b.namaLengkapPasien + '. AN BINTI ' + b.namaAyahPasien
			  when b.idJenisKelaminPasien = 1 and idStatusPerkawinanPasien in (2,3) then b.namaLengkapPasien + '. TN BIN ' + b.namaAyahPasien
			  when b.idJenisKelaminPasien = 1 and idStatusPerkawinanPasien in (1) and DATEDIFF(hour,tglLahirPasien,GETDATE())/8766>16 then b.namaLengkapPasien + '. TN BIN ' + b.namaAyahPasien
			  when b.idJenisKelaminPasien = 1 and idStatusPerkawinanPasien in (1) and DATEDIFF(hour,tglLahirPasien,GETDATE())/8766< = 16 then  b.namaLengkapPasien + '. AN BIN ' + b.namaAyahPasien
		   End as namaPasien
		  ,b.tglLahirPasien
		  ,DATEDIFF(hour,b.tglLahirPasien,GETDATE())/8766 AS umur
		  ,ba.namaJenisKelamin
		  ,c.namaJenisPendaftaran
		  ,a.idStatusPendaftaran
		  ,CASE
			When @FlagPoli = 1 
				Then 1
				Else 0
			End
		   as FlagResep		 
		  ,CASE
			When @FlagPoli = 1 
				Then 1
				Else 0
			End
		   as FlagTindakan	
		  ,CASE
			When @FlagPoli = 0 
				Then 1
				Else 0
			End
		   as FlagTerima
	  FROM [dbo].[transaksiPendaftaranPasien] a 
		   Inner Join [dbo].[masterPasien] b On a.idPasien = b.idPasien
				Inner Join [dbo].[masterJenisKelamin] ba On b.idJenisKelaminPasien = ba.idJenisKelamin
		   Inner Join [dbo].[masterJenisPendaftaran] c On a.idJenisPendaftaran = c.idJenisPendaftaran
	 WHERE idRuangan = @idRuangan And idStatusPendaftaran>1 and idStatusPendaftaran<98
  ORDER BY noRM DESC,namaPasien	
END