-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE rajal_perawat_tppri_listImf
	-- Add the parameters for the stored procedure here
	@idPendaftaranPasien bigint,
	@idRuangan int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idJenisStok int = (Select idJenisStok From dbo.masterRuangan Where idRuangan = @idRuangan)
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idIMF, a.noIMF, a.tglIMF, b.NamaOperator
		  ,Case
				When Exists(Select Top 1 1 From dbo.farmasiResep xa
								   Inner Join dbo.farmasiResepDetail xb On xa.idResep = xb.idResep
								   Inner Join dbo.farmasiPenjualanDetail xc On xb.idResepDetail = xc.idResepDetail
							 Where a.idIMF = xa.idIMF)
					 Then 0
				Else 1
			End As flagDelete
	  FROM dbo.farmasiIMF a 
		   LEFT JOIN dbo.masterOperator b On a.idDokter = b.idOperator
		   LEFT JOIN dbo.masterRuangan c On a.idRuangan = c.idRuangan
	 WHERE a.idPendaftaranPasien = @idPendaftaranPasien AND c.idJenisStok = @idJenisStok
END