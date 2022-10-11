-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[farmasi_pengadaan_dashboard_batalValidasi]
	-- Add the parameters for the stored procedure here
	@idOrder bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiOrder WHERE idOrder = @idOrder AND idStatusOrder <> 2/*Order Divalidasi*/)
		BEGIN
			SELECT 'Tidak Dapat Batal Validasi, '+ b.namaStatusOrder AS respon, 0 AS responCode
			  FROM dbo.farmasiOrder a
				   LEFT JOIN dbo.farmasiOrderStatus b ON a.idStatusOrder = b.idStatusOrder
			 WHERE a.idOrder = @idOrder;
		END
	ELSE
		BEGIN
			UPDATE [dbo].[farmasiOrder]
			   SET idStatusOrder = 1/*Proses Entry Order*/
			 WHERE idOrder= @idOrder;

			Select 'Data Order Barang Farmasi Batal Divalidasi' AS respon, 1 AS responCode;
		END
END