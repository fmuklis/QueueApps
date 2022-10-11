-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_requestKegudang_editRequest]
	-- Add the parameters for the stored procedure here
	@idRetur bigint,
	@tanggalRetur date,
	@keterangan varchar(max)
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiRetur WHERE idRetur = @idRetur AND idStatusRetur <> 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Diedit, Request Retur Ke Gudang '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiRetur a
				   LEFT JOIN dbo.farmasiMasterStatusRetur b ON a.idStatusRetur = b.idStatusRetur
			 WHERE a.idRetur= @idRetur;
		END
	ELSE
		BEGIN
			UPDATE dbo.farmasiRetur
			   SET tanggalRetur = @tanggalRetur
				  ,keterangan = @keterangan
			 WHERE idRetur = @idRetur;

			SELECT 'Data Permintaan Retur Kegudang Berhasil Diupdate' AS respon, 1 AS responCode;
		END
END