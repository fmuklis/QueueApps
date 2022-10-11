-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[radiologi_pemeriksaan_dashboard_orderDitolak]
	-- Add the parameters for the stored procedure here
	@idOrder int,
	@keterangan varchar(max),
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiOrder a
			   Where a.idOrder = @idOrder And a.idStatusOrder = 1)
		Begin
			/*UPDATE Data Order Labor*/
			UPDATE [dbo].[transaksiOrder]
			   SET [idStatusOrder] = 10/*Ditolak*/
				  ,[keterangan] = @keterangan
			 WHERE idOrder = @idOrder;

			Select 'Permintaan Radiologi Ditolak' As respon, 1 As responCode;
		End
END