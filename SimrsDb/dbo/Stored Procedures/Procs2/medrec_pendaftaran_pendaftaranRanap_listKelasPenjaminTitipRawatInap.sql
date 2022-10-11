
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_listKelasPenjaminTitipRawatInap]
as
Begin
	set nocount on;

SELECT [idKelas]
      ,[namaKelas]
      ,[kodeKelas]
  FROM [dbo].[masterKelas] where penjamin=1
End