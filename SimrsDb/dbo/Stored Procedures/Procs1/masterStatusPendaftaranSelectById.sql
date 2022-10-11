CREATE PROCEDURE [dbo].[masterStatusPendaftaranSelectById]

as
Begin
	set nocount on;
	Select idStatusPendaftaran,namaStatusPendaftaran 
	  From dbo.masterStatusPendaftaran 
	 Where idStatusPendaftaran Between 4 And 6
End