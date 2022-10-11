-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE farmasi_pengadaan_orderDetail_deleteOrder
	-- Add the parameters for the stored procedure here
	@idOrder bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiOrder WHERE idOrder = @idOrder AND idStatusOrder <> 1/*Entry Order*/)
		BEGIN
			SELECT 'Tidak Dapat Dihapus, '+ b.namaStatusOrder AS respon, 0 AS responCode
			  FROM dbo.farmasiOrder a
				   LEFT JOIN dbo.farmasiOrderStatus b ON a.idStatusOrder = b.idStatusOrder
			 WHERE a.idOrder = @idOrder;
		END
	ELSE
		BEGIN
			DELETE [dbo].[farmasiOrder]
			 WHERE idOrder = @idOrder;

			Select 'Data Purchase Order Berhasil Dihapus' As respon, 1 As responCode;
		END
END