-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[keuangan_kasir_billingLaboratoriumPasienLuar_discountTindakan]
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
	If Exists(Select 1 From dbo.transaksiTindakanPasien a
					 Inner Join dbo.transaksiBillingHeader b On a.idPendaftaranPasien = b.idPendaftaranPasien And a.idJenisBilling = b.idJenisBilling And b.idJenisBayar = 1
			   Where a.idTindakanPasien = @idTindakanPasien)
		Begin
			Select 'Tidak Dapat Disimpan, Biaya Tindakan Telah Dibayar' As respon, 0 As responCode;
		End
	Else
		Begin
			UPDATE dbo.transaksiTindakanPasien 
			   SET diskonPersen = @diskonPersen
				  ,diskonTunai = @diskonTunai
			 WHERE idTindakanPasien = @idTindakanPasien;

			Select 'Diskon Tindakan/Pemeriksaan Berhasil Disimpan' As respon, 1 As responCode;
		End
END