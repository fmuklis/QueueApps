
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[rajal_perawatPoli_dashboard_batalOK]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiOrderOK Where idPendaftaranPasien = @idPendaftaranPasien And idStatusOrderOK = 1/*Order OK*/)
		Begin
			DELETE FROM [dbo].[transaksiOrderOK]
			  WHERE idPendaftaranPasien = @idPendaftaranPasien;
			Select 'Order OK Berhasil Dibatalkan' As respon, 1 As responCode;
		End
	Else
		Begin
			Select 'Gagal!. ' + b.statusOperasi As respon, 0 As responCode
			  From dbo.transaksiOrderOK a
				   Inner Join dbo.masterStatusRequestOK b On a.idStatusOrderOK = b.idStatusOrderOK
			 Where a.idPendaftaranPasien = @idPendaftaranPasien;
		End
END