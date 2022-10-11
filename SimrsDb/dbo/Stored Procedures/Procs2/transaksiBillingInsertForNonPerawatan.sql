-- =============================================
-- Author     :	Start-X
-- Create date: <Create Date,,>
-- Description:	Untuk Menyimpan Billing Yang Bersifat Non Perawatan
-- =============================================
CREATE PROCEDURE [dbo].[transaksiBillingInsertForNonPerawatan]
	-- Add the parameters for the stored procedure here
	 @idPendaftaran int
    ,@idUser int
	,@idMasterTarif int
	,@biaya money
	,@idJenisBilling int
	,@tipeBilling int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @kodeBayar nchar(10);
	Declare @idBilling int;
	Declare @kodeBayarTertinggi int
		If Exists(Select 1 from transaksiBillingHeader)
			Begin
				Select @kodeBayarTertinggi=convert(int,max(kodeBayar)) from transaksiBillingHeader;
				Select @kodeBayar= case len(convert(nvarchar,@kodeBayarTertinggi+1))
					when 1 then '000000000' + convert(nvarchar,@kodeBayarTertinggi+1)
					when 2 then '00000000' + convert(nvarchar,@kodeBayarTertinggi+1)
					when 3 then '0000000' + convert(nvarchar,@kodeBayarTertinggi+1)
					when 4 then '000000' + convert(nvarchar,@kodeBayarTertinggi+1)
					when 5 then '00000' + convert(nvarchar,@kodeBayarTertinggi+1)
					when 6 then '0000' + convert(nvarchar,@kodeBayarTertinggi+1)
					when 7 then '000' + convert(nvarchar,@kodeBayarTertinggi+1)
					when 8 then '00' + convert(nvarchar,@kodeBayarTertinggi+1)
					when 9 then '0' + convert(nvarchar,@kodeBayarTertinggi+1)
					when 10 then convert(nvarchar,@kodeBayarTertinggi+1)
				End
			End
		Else
			Begin
				SET @kodeBayar='0000000001'
			End
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If @tipeBilling = 1 --Tipe Biling Selain Farmasi
	Begin Try
		Begin Tran tranBillingInsertForNonPerawat;
		If Not Exists(Select 1 From transaksiBillingHeader Where idPendaftaranPasien = @idPendaftaran And idJenisBilling = @idJenisBilling)
			Begin
				INSERT INTO [dbo].[transaksiBillingHeader]
						   ([idPendaftaranPasien]
						   ,[kodeBayar]
						   ,idJenisBilling
						   ,[idUserEntry])
					 VALUES
						   (@idPendaftaran
						   ,@kodeBayar
						   ,@idJenisBilling
						   ,@idUser);				
			End

		Select @idBilling = idbilling From dbo.transaksiBillingHeader Where idPendaftaranPasien = @idPendaftaran And idJenisBilling = @idJenisBilling;
			
		If Not Exists(Select 1 From transaksiBillingDetail Where idBilling = @idBilling And idMasterTarif = @idMasterTarif)
			Begin
				INSERT INTO [dbo].[transaksiBillingDetail]
						   ([idBilling]
						   ,[idMasterTarif]
						   ,[Nilai]
						   ,[jumlah])
					 VALUES
						   (@idBilling
						   ,@idMasterTarif
						   ,@biaya
						   ,1);
			End
		Commit Tran tranBillingInsertForNonPerawat;
		Select 'Data Berhasil Disimpan' as respon, 1 as responCode;
	End Try
	Begin Catch
		Rollback Tran tranBillingInsertForNonPerawat;
		Select 'Error !' + ERROR_MESSAGE() as respon, 0 as responCode
	End Catch
	Else
		Begin
			Select 'Data Berhasil Disimpan' as respon, 1 as responCode;
		End
END