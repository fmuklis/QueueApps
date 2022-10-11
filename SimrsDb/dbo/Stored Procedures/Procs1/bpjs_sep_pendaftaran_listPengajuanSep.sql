-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[bpjs_sep_pendaftaran_listPengajuanSep]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idPengajuan, a.noKartu, c.noRM, c.namaPasien, a.tanggalSep, a.keterangan
		  ,CASE
				WHEN a.jenisPelayanan = 1
					 THEN 'Rawat Inap'
				ELSE 'Rawat Jalan'
			END AS jenisPelayanan
			,CASE
				WHEN a.jenisPengajuan = 1
						THEN 'Backdate'
				ELSE 'Finger Print'
			END AS jenisPengajuan
		  ,CASE
				WHEN a.approve = 1
					 THEN 'Di Approve'
				ELSE 'Menunggu Approve'
			END AS [status]
		  ,CASE
				WHEN approve = 1
					 THEN 0
				ELSE 1
			END AS btnApproval
	  FROM dbo.bpjsSepPengajuan a
		   LEFT JOIN dbo.masterPasien b ON a.noKartu = b.noBPJS
		   OUTER APPLY dbo.getInfo_dataPasien(b.idPasien) c
	 WHERE a.approve = 0 OR DATEDIFF(day, a.tanggalEntry, GETDATE()) <= 7/*Seminggu*/
  ORDER BY a.approve, a.tanggalEntry DESC
END