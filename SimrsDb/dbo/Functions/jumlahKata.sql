CREATE FUNCTION [dbo].[jumlahKata]
(
	@namaLengkap nvarchar(200)
)
RETURNS int
as
Begin
	Declare @jumlahKata int;
	
DECLARE @t TABLE (txt VARCHAR(50))

INSERT INTO @t (txt)
VALUES (@namaLengkap);

	SELECT @jumlahKata = LEN(txt) - LEN(REPLACE(txt, ' ', '')) + 1 FROM @t;
RETURN @jumlahKata;
End