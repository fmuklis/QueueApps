-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ranap_perawat_entryTindakan_deleteOrderOK]
	-- Add the parameters for the stored procedure here
	@idTransaksiOrderOK int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiOrderOK Where idTransaksiOrderOK = @idTransaksiOrderOK And idStatusOrderOK = 1/*Order OK*/)
		Begin
			DELETE [dbo].[transaksiOrderOK]
			 WHERE idTransaksiOrderOK = @idTransaksiOrderOK;

			Select 'Order OK Berhasil Dibatalkan' As respon, 1 As responCode;
		End
	Else
		Begin
			Select 'Gagal!. ' + b.statusOperasi As respon, 0 As responCode
			  From dbo.transaksiOrderOK a
				INNER JOIN dbo.masterStatusRequestOK b ON a.idStatusOrderOK = b.idStatusOrderOK
			 Where a.idTransaksiOrderOK = @idTransaksiOrderOK;
		End
END