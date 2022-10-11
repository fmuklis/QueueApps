-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[keuangan_adminKeuangan_masterTarif_addPelayanan]
	-- Add the parameters for the stored procedure here
	@namaMasterPelayanan nvarchar(225)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	If Not Exists(Select 1 From dbo.masterPelayanan Where namaMasterPelayanan = @namaMasterPelayanan)
		Begin
			INSERT INTO [dbo].[masterPelayanan]
					   ([namaMasterPelayanan])
				 VALUES
					   (UPPER(@namaMasterPelayanan));

			Select 'Data Berhasil Disimpan' As respon, 1 As responCode;
		End
	Else 
		Begin
			Select 'Tidak Dapat Disimpan, Data Sudah Ada' As respon, 0 As responCode;
		End
END