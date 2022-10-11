-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingIgd_addDiscountTindakan]
	-- Add the parameters for the stored procedure here
	@idTindakanPasien int,
	@diskonPersen decimal(18,2),
	@diskonTunai money

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
			SELECT 'Tidak Dapat Disimpan, Biaya Tindakan / Pemeriksaan Telah Dibayar' AS respon, 0 AS responCode;
		END
	ELSE
		BEGIN
			UPDATE dbo.transaksiTindakanPasien 
			   SET diskonPersen = @diskonPersen
				  ,diskonTunai = @diskonTunai
			 WHERE idTindakanPasien = @idTindakanPasien;

			SELECT 'Diskon Tindakan / Pemeriksaan Berhasil Disimpan' AS respon, 1 AS responCode;
		END
END