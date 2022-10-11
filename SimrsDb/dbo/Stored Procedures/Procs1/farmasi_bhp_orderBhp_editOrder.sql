-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_bhp_orderBhp_editOrder]
	-- Add the parameters for the stored procedure here
	@idMutasi bigint,
	@tanggalOrder date,
	@keterangan varchar(max)
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiMutasi WHERE idMutasi = @idMutasi AND idStatusMutasi <> 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Diedit, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiMutasi a
				   LEFT JOIN dbo.farmasiMasterStatusMutasi b ON a.idStatusMutasi = b.idStatusMutasi
			 WHERE a.idMutasi = @idMutasi;
		END
	ELSE
		BEGIN
			UPDATE dbo.farmasiMutasi
			   SET tanggalOrder = @tanggalOrder
				  ,keterangan = @keterangan
			 WHERE idMutasi = @idMutasi;

			SELECT 'Data Permintaan BHP Berhasil Diupdate' AS respon, 1 AS responCode;
		END
END