-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasiIMFOrderInsert] 
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int
    ,@idRuangan int
    ,@idDokter int
    ,@tglIMF date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idJenisStok int = (Select idJenisStok From dbo.masterRuangan Where idRuangan = @idRuangan);
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	If Not Exists(Select 1 From dbo.farmasiIMF a
						 Inner Join dbo.masterRuangan b On a.idRuangan = b.idRuangan
				   Where idPendaftaranPasien = @idPendaftaranPasien And b.idJenisStok = @idJenisStok  And idDokter = @idDokter)
		Begin
			INSERT INTO [dbo].[farmasiIMF]
					   ([idPendaftaranPasien]
					   ,[idRuangan]
					   ,[idDokter]
					   ,[tglIMF]
					   ,[tglEntry]
					   ,[idUserEntry])
				 VALUES
					   (@idPendaftaranPasien
					   ,@idRuangan
					   ,@idDokter
					   ,@tglIMF
					   ,GetDate()
					   ,1);
			Select 'Permintaan Instruksi Medis Farmasi Berhasil Disimpan' As respon, 1 As responCode;
		End
	Else
		Begin
			Select 'Permintaan IMF Ke '+ namaJenisStok +' Dengan Dokter '+ c.NamaOperator +' Sudah Ada, Tidak Perlu Diorder Lagi' As respon, 0 As responCode
			  From dbo.farmasiIMF a
				   Inner Join dbo.masterRuangan b On a.idRuangan = b.idRuangan
						Inner Join dbo.farmasiMasterObatJenisStok ba On b.idJenisStok = ba.idJenisStok
				   Inner Join dbo.masterOperator c On a.idDokter = c.idOperator
			 Where idPendaftaranPasien = @idPendaftaranPasien And idDokter = @idDokter;
		End
END