-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laporan_Pembayaran_RaNap_GetUser]
	-- Add the parameters for the stored procedure here
	@periodeAwal date 
	,@periodeAkhir date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements. 
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.idUser, b.namaLengkap
	  FROM dbo.transaksiBillingHeader a
		   Inner Join dbo.masterUser b On a.idUserBayar = b.idUser
	 WHERE a.idJenisBilling = 6/*Billing Rawat Inap*/ And Convert(date, a.tglBayar) Between @periodeAwal And @periodeAkhir
  GROUP BY b.idUser, b.namaLengkap
  ORDER BY b.namaLengkap
END