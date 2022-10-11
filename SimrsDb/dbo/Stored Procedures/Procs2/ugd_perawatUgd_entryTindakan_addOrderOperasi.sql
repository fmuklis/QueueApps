CREATE procedure [dbo].[ugd_perawatUgd_entryTindakan_addOrderOperasi]

            @idPendaftaranPasien int 
           ,@tglOrder datetime 
           ,@idRuanganAsal int 
		   ,@idUserEntry int
as
Begin
	set nocount on;
	If not exists(Select 1 from transaksiOrderOK a where idPendaftaranPasien = @idPendaftaranPasien and idStatusOrderOK in (1,2))
	Begin
	INSERT INTO [dbo].[transaksiOrderOK]
			   ([idPendaftaranPasien]
			   ,[tglOrder]
			   ,[idRuanganAsal]
			   ,[idStatusOrderOK]
			   ,[idUserEntry]
			   ,[tglEntry])
		 VALUES
			   (@idPendaftaranPasien--int 
			   ,@tglOrder--datetime 
			   ,@idRuanganAsal--int 
			   ,1
			   ,@idUserEntry
			   ,GETDATE());

			   Select 'Data berhasil disimpan' as respon,1 as responCode;
		End
		else
		Begin
			 Select 'Masih ada order operasi yg belum selesai pada pasien ini' as respon,0 as responCode;
		End
end