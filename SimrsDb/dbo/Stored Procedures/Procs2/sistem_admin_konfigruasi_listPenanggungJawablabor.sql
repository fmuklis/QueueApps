-- =============================================
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Menampilkan Operator Berdasarkan Jenisnya
-- =============================================
CREATE PROCEDURE [dbo].[sistem_admin_konfigruasi_listPenanggungJawablabor]
	-- Add the parameters for the stored procedure here
	

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
		Begin
			SELECT idOperator
				  ,NamaOperator
			  FROM dbo.masterOperator a
				   Inner Join dbo.masterOperatorJenis b On a.idJenisOperator = b.idJenisOperator
			 WHERE b.idMasterKatagoriTarip In(1,3);
		End
	
END