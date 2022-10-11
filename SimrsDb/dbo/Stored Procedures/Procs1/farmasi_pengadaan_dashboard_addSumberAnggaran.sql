-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE farmasi_pengadaan_dashboard_addSumberAnggaran
	-- Add the parameters for the stored procedure here
	@orderSumberAnggaran varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 FRom dbo.farmasiOrderSumberAnggaran Where orderSumberAnggaran = @orderSumberAnggaran)
		Begin
			Select 'Sumber Anggaran Telah Terdaftar' As respon, 0 As responCode;
		End
	Else
		Begin
			INSERT INTO [dbo].[farmasiOrderSumberAnggaran]
				   ([orderSumberAnggaran])
			 VALUES
				   (@orderSumberAnggaran);

			Select 'Data Sumber Anggaran Berhasil Disimpan' As respon, 1 As responCode;
		End
END