-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterKelasSelectForOk] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [idKelas]
		  ,Case 
				When idKelas <> 99
					 Then [namaKelas]
				Else 'Operasi Kecil/ODC/Khusus'
			End As namaKelas
	  FROM [dbo].[masterKelas]
	 WHERE idKelas In(50,51,99)
  ORDER BY idKelas
END