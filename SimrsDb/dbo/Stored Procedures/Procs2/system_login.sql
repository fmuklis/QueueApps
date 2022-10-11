-- =============================================
-- Author:		takin788
-- Create date: 06-07-2018
-- Description:	untuk login user
-- =============================================
CREATE PROCEDURE [dbo].[system_login]
	-- Add the parameters for the stored procedure here
		@username nvarchar(25), 
	    @password nvarchar(50),
		@ip nvarchar(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.masterUser Where userName = @userName And userPassword = @password)
		Begin
			Select 'User Name Tidak Ada Atau Password Salah' As respon, 0 As responCode;
		End
	/*Else If Not Exists(Select 1 From dbo.masterUser	a 
							  Inner Join dbo.masterMenuSubGroupMember b On a.idGroupUser = b.idGroupUser 
							  Inner Join dbo.masterMenuSub c On b.idSubMenu = c.idSubMenu 
									Inner Join dbo.masterMenu ca On c.idMenu = ca.idMenu 
						Where a.userName = @userName)
		Begin
			Select 'User Belum Memiliki Hak-akses Menu, Hubungi IT' As respon, 0 As responCode;
		End*/
	Else
		Begin
			Select Distinct 'Login Sukses' As respon, 1 As responCode, GetDate() As TglLogin, GetDate() As JamLogin, a.idUser, a.userName, a.namaLengkap, a.noKaryawan
				  ,a.idGroupUser, a.userPassword, a.noHp, a.nik, ca.namaRumahSakit, ca.namaPendekRumahSakit, ca.kodeRS, ca.alamat, ca.kodePos, ca.kota
				  ,ca.telp, ca.email, d.idJenisStok, ca.namaDirektur, ca.namaSekretaris, ca.headerSurat1, d.idRuangan, d.namaRuangan, d.idJenisRuangan
				  ,18 As idMasperPelayananLaboratorium
				  ,(Select xa.idNegara From dbo.masterNegara xa Where xa.flagDefault = 1) As idNegara
				  ,(Select xa.idProvinsi From dbo.masterProvinsi xa Where xa.flagDefault = 1) As idProvinsi
				  ,(Select xa.idKabupaten From dbo.masterKabupaten xa Where xa.flagDefault = 1) As idKabupaten
				  ,(Select xa.idWargaNegara From dbo.masterWargaNegara xa Where xa.flagDefault = 1) As idWargaNegara
			  From dbo.masterUser a 
				   Left Join dbo.masterMenuSubGroupMember b On a.idGroupUser = b.idGroupUser 
						Left Join dbo.masterMenuSub ba On b.idSubMenu = ba.idSubMenu 
						Left Join dbo.masterMenu bb On ba.idMenu = bb.idMenu 
				   Inner Join dbo.masterUserGroup c On a.idGroupUser = c.idGroupUser
						Inner Join dbo.masterRumahSakit ca On c.idRumahSakit = ca.idRumahSakit
				   Inner Join dbo.masterRuangan d On a.idRuangan = d.idRuangan 
			Where a.userName = @userName;
		End
END