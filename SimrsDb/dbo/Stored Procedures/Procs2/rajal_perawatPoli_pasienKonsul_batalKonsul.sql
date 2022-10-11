-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[rajal_perawatPoli_pasienKonsul_batalKonsul]
	-- Add the parameters for the stored procedure here
	@idTransaksiKonsul bigint
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	IF EXISTS(SELECT * FROM dbo.transaksiKonsul WHERE idTransaksiKonsul = @idtransaksiKonsul AND idStatusKonsul <> 1/*Permintaan Poli*/)
		BEGIN
			SELECT 'Tidak Dapat Dibatalkan, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.transaksiKonsul a
				   LEFT JOIN dbo.masterStatusKonsul b ON a.idStatusKonsul = b.idStatusKonsul
			 WHERE a.idTransaksiKonsul = @idTransaksiKonsul;
		END
	ELSE
		BEGIN
			DELETE dbo.transaksiKonsul WHERE idTransaksiKonsul = @idtransaksiKonsul;
			SELECT 'Permintaan Konsul Dibatalkan / Ditolak' AS respon, 1 AS responCode;
		End
END