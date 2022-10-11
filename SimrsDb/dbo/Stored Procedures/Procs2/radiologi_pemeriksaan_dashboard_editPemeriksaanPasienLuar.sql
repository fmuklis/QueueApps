-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[radiologi_pemeriksaan_dashboard_editPemeriksaanPasienLuar]
	-- Add the parameters for the stored procedure here
	@idOrder bigint,
	@nama varchar(250),
	@idJenisKelamin tinyint,
	@tglLahir date,
	@alamat varchar(250),
	@dokter varchar(250),
	@tlp varchar(15),
    @tglOrder datetime,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idPasienLuar bigint = (SELECT idPasienLuar FROM dbo.transaksiOrder WHERE idOrder = @idOrder);

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.transaksiOrder WHERE idOrder = @idOrder AND idStatusOrder > 2/*Proses Entry Pemeriksaan*/)
		BEGIN
			SELECT 'Tidak Dapat Diedit, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.transaksiOrder a
				   LEFT JOIN dbo.masterStatusOrder b ON a.idStatusOrder = b.idStatusOrder
			 WHERE a.idOrder = @idOrder;
		END
	ELSE
		BEGIN
			UPDATE dbo.masterPasienLuar
			   SET nama = @nama
				  ,alamat = @alamat
				  ,idJenisKelamin = @idJenisKelamin
				  ,tglLahir = @tglLahir
				  ,dokter = @dokter
				  ,tlp = @tlp
			 WHERE idPasienLuar = @idPasienLuar;

			/*Update Data Request Radiologi*/
			UPDATE [dbo].[transaksiOrder]
			   SET [tglOrder] = @tglOrder
				  ,[idUserEntry] = @idUserEntry
			 WHERE idOrder = @idOrder;

			SELECT 'Data Pemeriksaan Radiologi Pasien Luar Berhasil Diupdate' AS respon, 1 AS responCode;
		END
END