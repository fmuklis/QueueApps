
create PROCEDURE [dbo].[casemix_penagihan_klaimBpjs_listJnisBayar]

AS
BEGIN
	SET NOCOUNT ON;
Select idJenisBayar, namaJenisBayar from [dbo].[masterJenisBayar] 
Where idjenisBayar <> 2 order by idjenisBayar
END