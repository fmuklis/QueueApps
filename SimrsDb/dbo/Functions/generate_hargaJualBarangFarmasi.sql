-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[generate_hargaJualBarangFarmasi]
(
	-- Add the parameters for the function here
	@idObatDetail bigint
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @hargaJual int
		   ,@persentaseHargaJualFarmasi int = (SELECT persentaseHargaJualFarmasi FROM dbo.masterKonfigurasi);

	-- Add the T-SQL statements to compute the return value here
	SELECT @hargaJual = a.hargaPokok + (a.hargaPokok * @persentaseHargaJualFarmasi / 100)
	  FROM dbo.farmasiMasterObatDetail a
	 WHERE a.idObatDetail = @idObatDetail;

	-- Return the result of the function
	RETURN @hargaJual
END