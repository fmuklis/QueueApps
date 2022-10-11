
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Muklis F>
-- Create date: <Create 20,07,2018>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterRuanganRawatInapInsert] 
	-- Add the parameters for the stored procedure here
	@idRuangan int,
	@namaRuanganRawatInap nvarchar(250),
	@idKelas int,
	@idRuanganKhusus int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.masterRuanganRawatInap Where idRuangan = @idRuangan And namaRuanganRawatInap = @namaRuanganRawatInap And idKelas = @idKelas)
		Begin
			Select 'Ruangan: '+ Convert(nvarchar(50), @namaRuanganRawatInap) +' Kelas '+ a.namaKelas +' Sudah Ada' As respon, 0 As responCode
			  From dbo.masterKelas a
			 Where a.idKelas = @idKelas
		End
	Else
		Begin
			INSERT INTO dbo.masterRuanganRawatInap
					   ([idRuangan]
					   ,[namaRuanganRawatInap]
					   ,[idKelas]
					   ,[idJenisKelamin])
				 VALUES
					   (@idRuangan
					   ,@namaRuanganRawatInap
					   ,@idKelas
					   ,IIF(@idRuanganKhusus=0,NULL,@idRuanganKhusus));

			Select 'Data Bangsal Rawat Inap Berhasil Disimpan' As respon, 1 As responCode;
		End
END