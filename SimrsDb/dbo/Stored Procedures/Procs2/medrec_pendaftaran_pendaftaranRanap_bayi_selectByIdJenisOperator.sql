-- =============================================
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Menampilkan Operator Berdasarkan Jenisnya
-- =============================================
CREATE PROCEDURE [dbo].[medrec_pendaftaran_pendaftaranRanap_bayi_selectByIdJenisOperator]
	-- Add the parameters for the stored procedure here
	 @dokter bit
	,@perawat bit
	,@bidan bit

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If @dokter = 1
		Begin
			SELECT idOperator
				  ,NamaOperator
			  FROM dbo.masterOperator a
				   Inner Join dbo.masterOperatorJenis b On a.idJenisOperator = b.idJenisOperator
			 WHERE b.idMasterKatagoriTarip In(1,3);
		End
	Else
		Begin
			SELECT idOperator
				  ,NamaOperator
			  FROM dbo.masterOperator a
				   Inner Join dbo.masterOperatorJenis b On a.idJenisOperator = b.idJenisOperator
			 WHERE b.idMasterKatagoriTarip = 5;
		End
END