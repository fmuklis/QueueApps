-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterRuanganTempatTidurUpdate]
	-- Add the parameters for the stored procedure here
	@idTempatTidur int,
	@noTempatTidur int,
	@namaRuanganRawatInap nvarchar(50),
	@idKelas int,
	@status bit,
	@keteranganTempatTidur nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idRuanganRawatInap int = (Select idRuanganRawatInap From dbo.masterRuanganTempatTidur Where idTempatTidur = @idTempatTidur);
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.masterRuanganRawatInap Where namaRuanganRawatInap = @namaRuanganRawatInap And idKelas = @idKelas 
					 And idRuanganRawatInap <> @idRuanganRawatInap)
		Begin
			Select 'Ruangan '+ @namaRuanganRawatInap +' Sudah Ada' As respon, 0 As responCode;
		End
	Else If Exists(Select 1 From dbo.masterRuanganTempatTidur 
					Where idRuanganRawatInap = @idRuanganRawatInap And noTempatTidur = @noTempatTidur And idTempatTidur <> @idTempatTidur)
		Begin
			Select 'Tidak Dapat Disimpan, Bed: '+ Convert(nchar(10), @noTempatTidur) +' Sudah Ada Pada Ruangan '+ @namaRuanganRawatInap As respon, 0 As responCode;
		End
	Else
		Begin
			UPDATE a
			   SET namaRuanganRawatInap = @namaRuanganRawatInap
				  ,idKelas = @idKelas
			  FROM dbo.masterRuanganRawatInap a
				   Inner Join dbo.masterRuanganTempatTidur b On a.idRuanganRawatInap = b.idRuanganRawatInap
			 WHERE b.idTempatTidur = @idTempatTidur;

			UPDATE dbo.masterRuanganTempatTidur
			   SET noTempatTidur = @noTempatTidur
				  ,flagMasihDigunakan = @status
				  ,keteranganTempatTidur = @keteranganTempatTidur
			 WHERE idTempatTidur = @idTempatTidur;

			Select 'Data Bed Kamar Inap Berhasil Diupdate' As respon, 1 As responCode;
		End
END