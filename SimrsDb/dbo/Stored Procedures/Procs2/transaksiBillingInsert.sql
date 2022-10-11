CREATE PROCEDURE [dbo].[transaksiBillingInsert]
			@idPendaftaran int
           ,@idUser int
		   ,@idMasterTarif int
		   ,@jumlah int
		   ,@tipeBilling int
          
as
Begin
	Declare @kodeBayar nchar(10)
			,@idBilling int 
			,@Nilai money
			,@kodeBayarTertinggi int
			,@idJenisBilling int = (Select Case
												When (Select idMasterPelayanan From dbo.masterTarip Where idMasterTarif = @idMasterTarif) = 17
													Then 4
												When (Select idMasterPelayanan From dbo.masterTarip Where idMasterTarif = @idMasterTarif) = 18
													Then 2
												Else 1
											End)

	set nocount on;
	if exists(Select 1 from transaksiBillingHeader)
	Begin
		select @kodeBayarTertinggi=convert(int,max(kodeBayar)) from transaksiBillingHeader;
		select @kodeBayar= case len(convert(nvarchar,@kodeBayarTertinggi+1))
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
			end
	End
	else
	Begin
		set @kodeBayar='0000000001'
	End
	select @Nilai=sum(b.tarip) from masterTarip a inner join masterTaripDetail b on a.idMasterTarif=b.idMasterTarip  where a.idMasterTarif=@idMasterTarif
	set nocount on;

	If @tipeBilling = 1 --Tipe Biling Selain Farmasi
		Begin Try
			Begin Tran yauauuqb898989;
			If not exists(Select 1 from transaksiBillingHeader where idPendaftaranPasien = @idPendaftaran and idJenisBilling = @idJenisBilling)
			Begin
			INSERT INTO [dbo].[transaksiBillingHeader]
					   ([idPendaftaranPasien]
					   ,[kodeBayar]
					   ,idJenisBilling
					   ,[idUserEntry]
					   )
				 VALUES
					   (@idPendaftaran
					   ,@kodeBayar
					   ,@idJenisBilling
					   ,@idUser
					   );

					
			End
				select @idBilling = idbilling from transaksiBillingHeader where idPendaftaranPasien = @idPendaftaran and idJenisBilling = @idJenisBilling;
			
					If not exists(select 1 from transaksiBillingDetail where idBilling=@idBilling and idMasterTarif=@idMasterTarif)
					Begin
					INSERT INTO [dbo].[transaksiBillingDetail]
							   ([idBilling]
							   ,[idMasterTarif]
							   ,[Nilai]
							   ,[jumlah])
						 VALUES
							   (@idBilling
							   ,@idMasterTarif
							   ,@Nilai
							   ,@jumlah);
					End;
			
					update transaksiPendaftaranPasien set idStatusPendaftaran=98 where idPendaftaranPasien=@idPendaftaran;

					Commit Tran yauauuqb898989;
					select 'Data Berhasil Disimpan' as respon, 1 as responCode;
		End Try
		Begin Catch
			rollback Tran yauauuqb898989;
			Select 'Data tidak berhasil disimpan' as respon, 0 as responCode
		End Catch
	Else
		Begin
			select 'Data Berhasil Disimpan' as respon, 1 as responCode;
		End
End