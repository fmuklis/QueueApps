CREATE PROCEDURE [dbo].[masterSatuanTarifInsert]

  	@namaSatuanTarif nvarchar(50)

As
BEGIN
	SET NOCOUNT ON;
	IF NOT EXISTS (select 1 from masterSatuanTarif where [namaSatuanTarif] = @namaSatuanTarif)
	BEGIN
	INSERT INTO [dbo].[masterSatuanTarif]
           ([namaSatuanTarif])
     VALUES
           (@namaSatuanTarif);
	select 'Data Berhasil Disimpan' as respon, 1 as responCode;
	END
	ELSE
	BEGIN
	select 'Maaf Satuan Tarif Sudah Ada' as respon, 0 as responCode;
	END
END