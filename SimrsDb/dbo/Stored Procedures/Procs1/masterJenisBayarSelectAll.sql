
CREATE PROCEDURE [dbo].[masterJenisBayarSelectAll]

AS
BEGIN
	SET NOCOUNT ON;
Select * from [dbo].[masterJenisBayar] 
Where idjenisBayar <> 2 order by idjenisBayar
END