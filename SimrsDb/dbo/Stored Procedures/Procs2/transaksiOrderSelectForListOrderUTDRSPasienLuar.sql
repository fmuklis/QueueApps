-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiOrderSelectForListOrderUTDRSPasienLuar]
	-- Add the parameters for the stored procedure here
	@periodeAwal date,
	@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT a.idOrder, a.tglOrder, a.kodeOrder, b.nama, ba.namaJenisKelamin, b.tglLahir, b.alamat, b.tlp, b.dokter
		  ,Case
				When a.idStatusOrder < = 2
					 Then 1
				Else 0
			End As btnHapus
		  ,Case
				When a.idStatusOrder < = 2
					 Then 1
				Else 0
			End As btnEntry
		  ,Case
				When a.idStatusOrder < = 2
					 Then 1
				Else 0
			End As btnEdit
		  ,Case
				When a.idStatusOrder = 3 And Not Exists(Select 1 From dbo.transaksiOrder xa
															   Inner Join dbo.transaksiBillingHeader xb On xa.idOrder = xb.idOrder And xb.idJenisBayar Is Not Null
														 Where a.idOrder = xa.idOrder)
					 Then 1
				Else 0
			End As btnBatalValidasi			 
	  FROM dbo.transaksiOrder a
		   Inner Join dbo.masterPasienLuar b On a.idPasienLuar = b.idPasienLuar
				Inner Join dbo.masterJenisKelamin ba On b.idJenisKelamin = ba.idJenisKelamin
	 WHERE a.idRuanganTujuan = 57/*UTDRS*/ And Convert(date, a.tglOrder) Between @periodeAwal And @periodeAkhir
  ORDER BY a.tglOrder;
END