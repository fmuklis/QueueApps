-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE FUNCTION [dbo].[diagnosaPasien] 
(
	-- Add the parameters for the function here
	@idPendaftaranPasien bigint
)
RETURNS nvarchar(250)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @return nvarchar(250)

	-- Add the T-SQL statements to compute the return value here
	If Exists(Select 1 From dbo.transaksiDiagnosaPasien Where idMasterDiagnosa Is Null And idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			Select @return = diagnosaAwal From dbo.transaksiDiagnosaPasien Where idPendaftaranPasien = @idPendaftaranPasien;
		End
	Else
		Begin
			Select Distinct @return = Substring((Select ' + '+ Trim(xb.diagnosa)
												   From dbo.transaksiDiagnosaPasien xa
													    Inner Join dbo.masterDiagnosa xb On xa.idMasterDiagnosa = xb.idMasterDiagnosa
												  Where a.idPendaftaranPasien = xa.idPendaftaranPasien
										   FOR XML PATH ('')), 4, 1000)
			  From dbo.transaksiDiagnosaPasien a 
			 Where idPendaftaranPasien = @idPendaftaranPasien;
		End
	-- Return the result of the function
	RETURN @return
END