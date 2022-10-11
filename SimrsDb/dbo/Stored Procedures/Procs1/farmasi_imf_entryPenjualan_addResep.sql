-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[farmasi_imf_entryPenjualan_addResep] 
	-- Add the parameters for the stored procedure here
	 @idIMF int
    ,@tglResep date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	If Not Exists(Select 1 From dbo.farmasiResep Where idIMF = @idIMF And Convert(date, tglResep) = @tglResep And idStatusResep = 1)
		Begin
			INSERT INTO [dbo].[farmasiResep]
					   ([idIMF]
					   ,[noResep]
					   ,[idPendaftaranPasien]
					   ,[idRuangan]
					   ,[idDokter]
					   ,[tglResep]
					   ,[idStatusResep])
				 SELECT a.idIMF
					   ,dbo.noResep('R')
					   ,a.idPendaftaranPasien
					   ,a.idRuangan
					   ,a.idDokter
					   ,@tglResep
					   ,1
				   FROM dbo.farmasiIMF a
				  WHERE a.idIMF = @idIMF;
		End

	Select idResep, idPendaftaranPasien From dbo.farmasiResep Where idIMF = @idIMF AND CAST(tglResep AS date) = @tglResep AND idStatusResep = 1;
END