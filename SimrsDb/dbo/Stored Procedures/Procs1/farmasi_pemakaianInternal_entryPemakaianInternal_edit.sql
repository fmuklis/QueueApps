-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[farmasi_pemakaianInternal_entryPemakaianInternal_edit]
	-- Add the parameters for the stored procedure here
	@idPemakaianInternal bigint,
	@tanggalPermintaan date,
	@idBagian int,
	@pemohon varchar(50),
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiPemakaianInternal WHERE idStatusPemakaianInternal <> 1/*Proses Entr*/ AND idPemakaianInternal = @idPemakaianInternal)
		BEGIN
			SELECT 'Tidak Dapat Diedit, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiPemakaianInternal a
				   LEFT JOIN dbo.farmasiMasterStatusPemakaianInternal b ON a.idStatusPemakaianInternal = b.idStatusPemakaianInternal
			WHERE a.idPemakaianInternal = @idPemakaianInternal;
		END
	ELSE
		BEGIN
			UPDATE [dbo].[farmasiPemakaianInternal]
			   SET [tanggalPermintaan] = @tanggalPermintaan
				  ,[idBagian] = @idBagian
			      ,[pemohon] = @pemohon
				  ,[idUserEntry] = @idUserEntry
			 WHERE idPemakaianInternal = @idPemakaianInternal;

			SELECT 'Data Pemakaian Internal Berhasil Diupdate' AS respon, 1 AS responCode;
		END
END