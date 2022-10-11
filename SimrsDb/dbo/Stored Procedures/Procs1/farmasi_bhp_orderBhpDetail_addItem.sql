-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_bhp_orderBhpDetail_addItem]
	-- Add the parameters for the stored procedure here
	@idMutasi bigint,
	@idObatDosis int,
    @jumlahOrder decimal(18,2)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @sisaStok decimal(18, 2);

	SELECT @sisaStok = SUM(a.stok)
	  FROM dbo.farmasiMasterObatDetail a
		   INNER JOIN dbo.farmasiMutasi b ON a.idRuangan = b.idRuangan
	 WHERE b.idMutasi = @idMutasi;

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiMutasi WHERE idMutasi = @idMutasi AND idStatusMutasi <> 1/*Proses Entry*/)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiMutasi a
				   LEFT JOIN dbo.farmasiMasterStatusMutasi b ON a.idStatusMutasi = b.idStatusMutasi
			 WHERE a.idMutasi = @idMutasi;
		END
	ELSE IF EXISTS(SELECT 1 FROM dbo.farmasiMutasiOrderItem WHERE idMutasi = @idMutasi AND idObatDosis = @idObatDosis)
		BEGIN
			SELECT 'Tidak Dapat Disimpan, Sudah Ada Item Request Yang Sama' AS respon, 0 AS responCode
		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[farmasiMutasiOrderItem]
					   ([idObatDosis]
					   ,[sisaStok]
					   ,[jumlahOrder]
					   ,[idMutasi])
				 VALUES
					   (@idObatDosis
					   ,ISNULL(@sisaStok, 0)
					   ,@jumlahOrder
					   ,@idMutasi);

			SELECT 'Item Request BHP Berhasil Disimpan' AS respon, 1 AS responCode;
		END
END