-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[keuangan_adminKeuangan_masterTarif_addSatuanTarif]
	-- Add the parameters for the stored procedure here
	@namaSatuanTarif nvarchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.masterSatuanTarif Where [namaSatuanTarif] = @namaSatuanTarif)
		Begin
			INSERT INTO [dbo].[masterSatuanTarif]
					   ([namaSatuanTarif])
				 VALUES
						(@namaSatuanTarif);

			Select 'Data Berhasil Disimpan' As respon, 1 As responCode;
		End
	Else
		Begin
			Select 'Maaf Satuan Tarif Sudah Ada' As respon, 0 As responCode;
		End
END