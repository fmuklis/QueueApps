-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laporan_Pembayaran_RawatJalan_IGD]
	-- Add the parameters for the stored procedure here
	@periodeAwal date 
	,@periodeAkhir date
	,@idJenisBilling int
	,@idUserBayar int

WITH EXECUTE AS OWNER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements. 
	Declare @Query nvarchar(max)
		   ,@Where nvarchar(max) = Case
										When @idJenisBilling <> 0 And @idUserBayar = 0
											 Then 'And a.idJenisBilling = '+ Convert(nvarchar(50), @idJenisBilling) +''
										When @idJenisBilling = 0 And @idUserBayar <> 0
											 Then 'And a.idUserBayar = '+ Convert(nvarchar(50), @idUserBayar) +''
										When @idJenisBilling <> 0 And @idUserBayar <> 0
											 Then 'And a.idUserBayar = '+ Convert(nvarchar(50), @idUserBayar) +' And a.idJenisBilling = '+ Convert(nvarchar(50), @idJenisBilling) +''
										Else 'And a.idJenisBilling In(1,5)'
									End

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @Query = 'SELECT d.namaJenisBayar, a.tglBayar, ba.noRM, ba.namaPasien, bb.namaRuangan, c.namaLengkap
						,(Select Sum(xb.nilai)
							From dbo.transaksiTindakanPasien xa
								 Inner Join dbo.transaksiTindakanPasienDetail xb On xa.idTindakanPasien = xb.idTindakanPasien
						   Where a.idPendaftaranPasien = xa.idPendaftaranPasien And a.idJenisBilling = xa.idJenisBilling) As total
					FROM dbo.transaksiBillingHeader a
						 Inner Join dbo.transaksiPendaftaranPasien b On a.idPendaftaranPasien = b.idPendaftaranPasien
							Outer Apply (Select * From dbo.getInfo_dataPasien(b.idPasien) xa) ba 
							Inner Join dbo.masterRuangan bb On b.idRuangan = bb.idRuangan
						 Inner Join dbo.masterUser c On a.idUserBayar = c.idUser
						 Inner Join dbo.masterJenisBayar d On a.idJenisBayar = d.idJenisBayar
				   WHERE Convert(date, a.tglBayar) Between '''+ Convert(nvarchar(50), @periodeAwal) +''' And '''+ Convert(nvarchar(50), @periodeAkhir) +''''+ @Where +'
				ORDER BY d.namaJenisBayar, a.tglBayar, bb.namaRuangan';
	EXEC (@Query);
END