
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[getInfo_aturanPakai]
(
	-- Add the parameters for the function here
	@idResepDetail bigint
)
RETURNS TABLE
AS
RETURN
(
	-- Add the SELECT statement with parameter references here
	SELECT CAST(a.kaliKonsumsi AS varchar(10)) +' X ' + a.jumlahKonsumsi + ISNULL(' '+ b.namaTakaran, '') + ISNULL(' '+ c.namaResepWaktu, '') + ISNULL(' '+ d.saatKonsumsi, '') AS aturanPakai
		  ,a.keterangan
		  ,CASE
				WHEN a.idRacikan = 0
					 THEN 'Non Racikan'
				ELSE 'Racikan'
			END AS jenisResep
	  FROM dbo.farmasiResepDetail a
		   LEFT JOIN dbo.farmasiResepTakaran b On a.idTakaran = b.idTakaran
		   LEFT JOIN dbo.farmasiResepWaktu c On a.idResepWaktu = c.idResepWaktu
		   LEFT JOIN  dbo.farmasiResepSaatKonsumsi d On a.idSaatKonsumsi = d.idSaatKonsumsi
	 WHERE a.idResepDetail = @idResepDetail
)