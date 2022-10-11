CREATE PROCEDURE [dbo].[masterPenyakitSelectAll]
as
Begin
	set nocount on;
SELECT [idPenyakit]
      ,[namaPenyakit]
     
  FROM [dbo].[masterPenyakit]
End