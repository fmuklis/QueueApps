CREATE PROCEDURE [dbo].[transaksiTindakanPasienOperatorInsert]
	@idTindakanPasien int,
    @idOperator int
as
Begin
	set nocount on;
	If not exists(Select 1 from [transaksiTindakanPasienOperator] where idTindakanPasien = @idTindakanPasien and idOperator = @idOperator)
	Begin
			INSERT INTO [transaksiTindakanPasienOperator]
           ([idTindakanPasien]
           ,[idOperator])
     VALUES
           (@idTindakanPasien
           ,@idOperator);

		   SELECT 'Data Berhasil Disimpan' as respon, 1 as responCode;	
	End
End