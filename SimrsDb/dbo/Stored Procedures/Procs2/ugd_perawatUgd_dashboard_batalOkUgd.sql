-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[ugd_perawatUgd_dashboard_batalOkUgd]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiOrderOK WHERE idPendaftaranPasien = @idPendaftaranPasien AND idStatusOrderOK <> 1/*Order OK*/)
		BEGIN
			SELECT 'Tidak Dapat Dibatalkan, ' + b.caption AS respon, 0 AS responCode
			  FROM dbo.transaksiOrderOK a
				   LEFT JOIN dbo.masterStatusRequestOK b ON a.idStatusOrderOK = b.idStatusOrderOK
			 WHERE a.idPendaftaranPasien = @idPendaftaranPasien;
		END
	ELSE
		BEGIN
			DELETE [dbo].[transaksiOrderOK]
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			SELECT 'Request OK Dibatalkan' AS respon, 1 AS responCode;
		END
END