-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author	  : Start-X
-- Create date: <Create Date,,>
-- Description:	Daftar Tarif
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterTarip_SelectPivot] 
	-- Add the parameters for the stored procedure here
	 @idMasterPelayanan int = 99

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @cols AS NVARCHAR(MAX)
			,@query  AS NVARCHAR(MAX)
			,@where  AS NVARCHAR(MAX);

	SET @cols = STUFF((SELECT ',' + QUOTENAME([namaMasterKatagoriTarif]) 
				FROM [dbo].[masterTarifKatagori] 
				ORDER BY [namaMasterKatagoriTarif]
				FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)') 
			,1,1,'');


	Select @where = Case 
						When @idMasterPelayanan <> 99
							Then 'WHERE b.idMasterPelayanan = ' + CONVERT(nvarchar(100), @idMasterPelayanan)+''
						Else ''
					End
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @query = 'SELECT idMasterTarif,namaMasterPelayanan,idMasterTarifHeader,namaTarif,keterangan,namaKelas,idJenisTarif,namaJenisTarif,' + @cols + ' 
					FROM (SELECT ba.namaMasterPelayanan
								,b.idMasterTarifHeader
								,bb.namaTarifHeader As namaTarif
								,b.keterangan
								,bc.namaKelas
								,c.namaMasterKatagoriTarif
								,a.tarip
								,b.idMasterTarif 
								,b.idJenisTarif 
								,d.namaJenisTarif
							FROM masterTaripDetail a 
								 Inner Join [dbo].[masterTarip] b on b.idMasterTarif = a.idMasterTarip
									Inner Join dbo.masterPelayanan ba On b.idMasterPelayanan = ba.idMasterPelayanan
									Inner Join dbo.masterTarifHeader bb On b.idMasterTarifHeader = bb.idMasterTarifHeader
									Inner Join dbo.masterKelas bc On b.idKelas = bc.idKelas
									Inner Join dbo.masterJenisTarif bd On b.idJenisTarif = bd.idJenisTarif
									Inner Join dbo.masterSatuanTarif be On b.idSatuanTarif = be.idSatuanTarif
								 Inner Join [dbo].[masterTarifKatagori] c on a.idMasterKatagoriTarip = c.idMasterKatagoriTarip
								 Inner Join [dbo].[masterJenisTarif] d On b.idJenisTarif = d.idJenisTarif
								 '+ @where +' 
						GROUP BY ba.namaMasterPelayanan,b.idMasterTarifHeader,bb.namaTarifHeader,b.keterangan,bc.namaKelas,c.namaMasterKatagoriTarif,a.tarip,b.idMasterTarif ,b.idJenisTarif ,d.namaJenisTarif) x
					PIVOT (Sum(tarip)
						   For namaMasterKatagoriTarif in (' + @cols + ')) p
				 ORDER BY namaTarif,namaKelas'
	EXECUTE(@query);
END