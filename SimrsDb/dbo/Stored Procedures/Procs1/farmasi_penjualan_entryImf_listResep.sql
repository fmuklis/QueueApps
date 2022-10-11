-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_penjualan_entryImf_listResep]
	-- Add the parameters for the stored procedure here
	@idIMF bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idResep, a.idPendaftaranPasien, a.nomorResep AS noResep, a.tglResep, c.NamaOperator, b.alias, d.statusResep AS namaStatusResep
		  ,CASE 
				WHEN a.idStatusResep <= 2
					 THEN 1
				ELSE 0
			END AS btnEntry
		  ,CASE 
				WHEN a.idStatusResep <= 2
					 THEN 1
				ELSE 0
			END AS btnDelete
		  ,CASE 
				WHEN a.idStatusResep = 3
					 THEN 1
				ELSE 0
			END AS btnEticket
		  ,CASE 
				WHEN a.idStatusResep = 3
					 THEN 1
				ELSE 0
			END AS btnEresep
		  ,CASE 
				WHEN a.idStatusResep = 3 AND ISNULL(e.idStatusBayar, 1) = 1/*Menunggu Pembayaran*/
					 THEN 1
				ELSE 0
			END AS btnBatalValidasi
	  FROM dbo.farmasiResep a
		   LEFT JOIN dbo.masterRuangan b On a.idRuangan = b.idRuangan
		   LEFT JOIN dbo.masterOperator c On a.idDokter = c.idOperator
		   LEFT JOIN dbo.farmasiMasterStatusResep d On a.idStatusResep = d.idStatusResep
		   LEFT JOIN dbo.transaksiBillingHeader e ON a.idResep = e.idResep
	 WHERE a.idIMF = @idIMF
END