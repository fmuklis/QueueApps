-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[rajal_perawatPoli_entryTindakan_deleteKonsul]
	-- Add the parameters for the stored procedure here
	 @idTransaksiKonsul bigint
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	If Exists (Select 1 From dbo.transaksiKonsul Where idTransaksiKonsul = @idtransaksiKonsul And idStatusKonsul <> 1 /*Permintaan Poli*/)
		BEGIN
			SELECT 'Tidak Dapat Dibatalkan, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.transaksiKonsul a
				   LEFT JOIN dbo.masterStatusKonsul b ON a.idStatusKonsul = b.idStatusKonsul
			 WHERE a.idTransaksiKonsul = @idTransaksiKonsul;
		END
	Else
		BEGIN
			DELETE dbo.transaksiKonsul WHERE idTransaksiKonsul = @idTransaksiKonsul;
			SELECT 'Permintaan Konsul Dibatalkan' AS respon, 1 AS responCode;
		End
END