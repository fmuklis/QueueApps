-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Menampilkan Barang Yang telah Direquest
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  = 
CREATE PROCEDURE [dbo].[farmasi_pemakaianInternal_entryPemakaianInternal_batalValidasi]
	-- Add the parameters for the stored procedure here
	@idPemakaianInternal bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiPemakaianInternal WHERE idStatusPemakaianInternal <> 5/*Valid / Selesai*/
					 AND idPemakaianInternal = @idPemakaianInternal)
		BEGIN
			SELECT 'Tidak Dapat Batal Validasi, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiPemakaianInternal a
				   LEFT JOIN dbo.farmasiMasterStatusPemakaianInternal b ON a.idStatusPemakaianInternal = b.idStatusPemakaianInternal
			 WHERE a.idPemakaianInternal = @idPemakaianInternal;
		END
	ELSE
		BEGIN
			UPDATE dbo.farmasiPemakaianInternal
			   SET [idStatusPemakaianInternal] = 1/*Proses Entry*/
				  ,[idPetugas] = NULL
				  ,[kodePemakaianInternal] = NULL
				  ,[tanggalModifikasi] = NULL
			 WHERE idPemakaianInternal = @idPemakaianInternal;

			SELECT 'Data Pemakaian Internal Batal Divalidasi' AS respon, 1 AS responCode;
		END
END