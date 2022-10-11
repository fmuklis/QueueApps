-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiOrderUpdateForOrderLabPasienLuar]
	-- Add the parameters for the stored procedure here
	@idOrder int,
	@nama nvarchar(250),
	@idJenisKelamin int,
	@tglLahir date,
	@alamat nvarchar(250),
	@dokter nvarchar(250),
	@tlp nvarchar(15),
	@tglOrder date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.transaksiOrderDetail a
					 Inner Join dbo.transaksiTindakanPasien b On a.idOrderDetail = b.idOrderDetail
					 Inner Join dbo.transaksiBillingHeader c On a.idOrder = c.idOrder And c.idJenisBayar Is Not Null
			   Where a.idOrder = @idOrder)
		Begin
			Select 'Tidak Dapat Diedit, Pemeriksaan Laboratorium Telah Dibayar' As respon, 0 As responCode;
		End
	Else
		Begin
			/*UPDATE Edit Data Pasien Luar*/
			UPDATE a
			   SET [nama] = @nama
				  ,[idJenisKelamin] = @idJenisKelamin
				  ,[tglLahir] = @tglLahir
				  ,[alamat] = @alamat
				  ,[dokter] = @dokter
				  ,[tlp] = @tlp
			  FROM dbo.masterPasienLuar a
				   Inner Join dbo.transaksiOrder b On a.idPasienLuar = b.idPasienLuar
			 WHERE b.idOrder = @idOrder;

			/*UPDATE Data Tgal Order*/
			UPDATE dbo.transaksiOrder
			   SET tglOrder = @tglOrder
			 WHERE idOrder = @idOrder;
		
			/*Respon*/		   	
			Select 'Data Pemeriksaan Laboratorium Berhasil Diupdate' As respon, 1 As responCode;								
		End
END