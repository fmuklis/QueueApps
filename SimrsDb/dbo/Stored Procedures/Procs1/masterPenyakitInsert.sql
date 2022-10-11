CREATE PROCEDURE [dbo].[masterPenyakitInsert]
			@kodeICD nvarchar(30)
           ,@namaPenyakit nvarchar(225)
           ,@keterangan nvarchar(max)
as
Begin
	set nocount on;
	If Not Exists(Select 1 From masterPenyakit Where namaPenyakit = @namaPenyakit)  -- Request Rumahsakit Icd Boleh Kosong  kodeICD = @kodeICD
		Begin
				INSERT INTO [dbo].[masterPenyakit]
					   ([kodeICD]
					   ,[namaPenyakit]
					   ,[keterangan])
				 VALUES
					   (@kodeICD
					   ,@namaPenyakit
					   ,@keterangan);
					Select 'Data berhasil disimpan' As respon, 1 As responCode;
		End
	Else
		Begin
			Select 'Nama Penyakit Sudah Ada' As respon, 0 As responCode;
		End
End