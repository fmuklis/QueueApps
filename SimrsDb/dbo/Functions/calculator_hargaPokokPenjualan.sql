-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION calculator_hargaPokokPenjualan
(
	-- Add the parameters for the function here
	@jumlahBeli int,
	@hargaBeli decimal(18,2),
	@discountTunai int,
	@discountPersen decimal(18,2),
	@ppn decimal(18,2)

)
RETURNS decimal(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @discountTunaiSatuan decimal(18,2) = @discountTunai / @jumlahBeli
		  

	-- Add the T-SQL statements to compute the return value here

	-- Return the result of the function
	RETURN (
		SELECT @hargaBeli - @discountTunaiSatuan
				- ((@hargaBeli - @discountTunaiSatuan) * @discountPersen / 100)
				+ ((@hargaBeli - @discountTunaiSatuan - ((@hargaBeli - @discountTunaiSatuan) * @discountPersen / 100)) * @ppn / 100)
	)

END