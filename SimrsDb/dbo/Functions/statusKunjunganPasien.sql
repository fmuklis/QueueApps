-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[statusKunjunganPasien]
(
	-- Add the parameters for the function here
	@idPendaftaranPasien int
)
RETURNS nvarchar(5)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result nvarchar(5)
		   ,@idPasien int = (Select idPasien From dbo.transaksiPendaftaranPasien Where idPendaftaranPasien = @idPendaftaranPasien);

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = Case
						  When Exists(Select Top 1 1 From dbo.transaksiPendaftaranPasien a
									   Where a.idPasien = @idPasien And a.idPendaftaranPasien <> @idPendaftaranPasien 
											 And (Convert(date, a.tglDaftarPasien) < Convert(date, a.tglDaftarPasien) Or a.idpasien < 483))
								   Then 'Lama'
						  Else 'Baru'
					  End
	-- Return the result of the function
	RETURN @Result;
END