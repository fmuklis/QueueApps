-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_bayi_cetakGelang]
	-- Add the parameters for the stored procedure here
	 @idPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.noRM, b.tglLahirPasien
		  ,CASE dbo.jumlahKata(a.namaLengkapPasien)
				WHEN 1 
					 THEN b.namaPasien
				ELSE a.namaLengkapPasien
			END AS namaDiGelang
	  FROM dbo.masterPasien a 
		   OUTER APPLY dbo.getInfo_dataPasien(a.idPasien) b
	 WHERE a.idPasien = @idPasien
END