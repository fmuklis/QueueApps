-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_retur_requestKegudang_batalValidasi]
	-- Add the parameters for the stored procedure here
	@idRetur bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.farmasiRetur WHERE idRetur = @idRetur AND idStatusRetur <> 5/*Request Valid*/)
		BEGIN
			SELECT 'Tidak Dapat Batal Validasi, '+ b.caption AS respon, 0 AS responCode
			  FROM dbo.farmasiRetur a
				   LEFT JOIN dbo.farmasiMasterStatusRetur b ON a.idStatusRetur = b.idStatusRetur
			 WHERE a.idRetur = @idRetur;
		END
	ELSE
		BEGIN
			/*Update Status Retur*/
			UPDATE dbo.farmasiRetur
			   SET idStatusRetur = 1/*Proses Entry Request*/
				  ,kodeRetur = NULL
				  ,idPetugasRetur = NULL
			 WHERE idRetur = @idRetur;

			SELECT 'Request Retur Ke Gudang Farmasi Batal Divalidasi' AS respon, 1 AS responCode;
		END
END