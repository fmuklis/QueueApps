-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiOrderOKForIGDInsert]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int
	,@keterangan nvarchar(max)
	,@idUserEntry int
	,@tglOrder datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiOrderOK Where idPendaftaranPasien = @idPendaftaranPasien And idStatusOrderOK = 1)
		Begin
			Select 'Gagal, Data Sudah Ada' As respon, 0 As responCode;
		End
	Else
		Begin
			INSERT INTO [dbo].[transaksiOrderOK]
					   ([idPendaftaranPasien]
					   ,[idUserEntry]
					   ,[idStatusOrderOK]
					   ,[idRuanganAsal]
					   ,[tglOrder]
					   ,[tglEntry]
					   ,[keterangan])
				 SELECT a.idPendaftaranPasien
					   ,@idUserEntry
					   ,1/*Order*/				
					   ,a.idRuangan
					   ,@tglOrder
					   ,GetDate()
					   ,@keterangan	
				   FROM dbo.transaksiPendaftaranPasien a
				  WHERE a.idPendaftaranPasien = @idPendaftaranPasien;
			Select 'Data Berhasil Disimpan' As respon, 1 As responCode;
		End
END