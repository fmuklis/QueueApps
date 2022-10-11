-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiOrderInsertForOrderUTDRS]
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien int,
	@idUserEntry int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.transaksiOrder Where idPendaftaranPasien = @idPendaftaranPasien And idStatusOrder < 3 And idRuanganTujuan = 57/*UTDRS*/)
		Begin
			/*INSERT Entry Data Order UTDRS*/
			INSERT INTO [dbo].[transaksiOrder]
					   ([idRuanganAsal]
					   ,[idRuanganTujuan]
					   ,[idPendaftaranPasien]
					   ,[idDokter]
					   ,[tglOrder]
					   ,[idUserEntry]
					   ,[idStatusOrder]
					   ,[idUserTerima])
				 SELECT a.idRuangan
					   ,57/*UTDRS*/
					   ,a.idPendaftaranPasien
					   ,a.idDokter
					   ,GetDate()
					   ,@idUserEntry
					   ,2/*Diterima*/
					   ,@idUserEntry
				   FROM dbo.transaksiPendaftaranPasien a
				  WHERE a.idPendaftaranPasien = @idPendaftaranPasien;
		End

	/*Respon*/		   	
	Select a.idOrder
	  From dbo.transaksiOrder a
	 Where a.idRuanganTujuan = 57/*UTDRS*/ And a.idPendaftaranPasien = @idPendaftaranPasien And a.idStatusOrder < 3;
END