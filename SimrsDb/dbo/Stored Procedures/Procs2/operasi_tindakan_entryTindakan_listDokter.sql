-- =============================================
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Menampilkan Operator Berdasarkan Jenisnya
-- =============================================
CREATE PROCEDURE operasi_tindakan_entryTindakan_listDokter
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT idOperator, NamaOperator
      FROM dbo.masterOperator a
		   INNER JOIN dbo.masterOperatorJenis b On a.idJenisOperator = b.idJenisOperator 
	 WHERE b.idMasterKatagoriTarip IN(1,3)
  ORDER BY NamaOperator
END