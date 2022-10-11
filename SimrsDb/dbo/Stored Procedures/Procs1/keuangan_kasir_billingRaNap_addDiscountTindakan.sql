-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingRaNap_addDiscountTindakan]
	-- Add the parameters for the stored procedure here
	@idTindakanPasien int,
	@diskonTunai money,
	@diskonPersen decimal(18,2)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiTindakanPasien a
					 INNER JOIN dbo.transaksiBillingHeader b ON a.idPendaftaranPasien = b.idPendaftaranPasien AND a.idJenisBilling = b.idJenisBilling AND b.idStatusBayar <> 1/*Menunggu Pembayaran*/
			   WHERE a.idTindakanPasien = @idTindakanPasien)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Biaya Tindakan/Pemeriksaan Telah Dibayar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			UPDATE dbo.transaksiTindakanPasien 
			   SET diskonPersen = @diskonPersen
				  ,diskonTunai = @diskonTunai
			 WHERE idTindakanPasien = @idTindakanPasien;

			Select 'Diskon Tindakan/Pemeriksaan Berhasil Disimpan' As respon, 1 As responCode;
		END
END