-- =============================================
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Menampilkan Operator Berdasarkan Jenisnya
-- =============================================
CREATE PROCEDURE [dbo].[sistem_admin_konfigurasi_listData]
	-- Add the parameters for the stored procedure here
	

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	Begin
			SELECT persentaseHargaJualFarmasi
				  ,idPenanggungJawabLaboratorium
				  ,bhpDitagihkan
			  FROM dbo.masterKonfigurasi 
				  
	End
	
END