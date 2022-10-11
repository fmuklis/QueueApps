-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterRuanganTempatTidurSelectAll] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idTempatTidur, ba.namaRuangan As namaGedung, b.namaRuanganRawatInap, c.namaKelas As namaKelasRuangan
		  ,a.noTempatTidur, a.flagMasihDigunakan
		  ,Case
				When Exists(Select Top 1 1 From dbo.transaksiPendaftaranPasienDetail xa Where a.idTempatTidur = xa.idTempatTidur)
					 Then 0
				Else 1
			End As btnDelete
	  FROM dbo.masterRuanganTempatTidur a 
		   Inner Join dbo.masterRuanganRawatInap b On a.idRuanganRawatInap = b.idRuanganRawatInap
				Inner Join dbo.masterRuangan ba On b.idRuangan = ba.idRuangan 
		   Inner Join dbo.masterKelas c on b.idKelas = c.idKelas
  ORDER BY c.namaKelas
END