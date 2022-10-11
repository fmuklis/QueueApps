-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[operasi_tindakan_entryTindakan_addDetailOperasi]
	-- Add the parameters for the stored procedure here
     @idTransaksiOrderOK int
	 ,@idGolonganOk int
     ,@idGolonganSpinal int
     ,@idGolonganSpesialis int
     ,@tglOperasi date
     ,@jamMulai time(7)
     ,@jamSelesai time(7)
     ,@tglAnestesi date
     ,@jamMulaiAnestesi time(7)
     ,@jamSelesaiAnestesi time(7)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[transaksiOrderOK]
	   SET [tglOperasi] = @tglOperasi
		  ,[jamMulai] = @jamMulai
		  ,[jamSelesai] = @jamSelesai
		  ,[tglAnestesi] = @tglAnestesi
		  ,[jamMulaiAnestesi] = @jamMulaiAnestesi
		  ,[jamSelesaiAnestesi] = @jamSelesaiAnestesi
		  ,[idGolonganOk] = @idGolonganOk
		  ,[idGolonganSpinal] = @idGolonganSpinal
		  ,[idGolonganSpesialis] = @idGolonganSpesialis
	 WHERE [idTransaksiOrderOK] = @idTransaksiOrderOK
	 Select 'Data Berhasil Diupdate' As respon, 1 As responCode;
END