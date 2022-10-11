-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[laporanPembayaranPenunjangGetUser]
	-- Add the parameters for the stored procedure here
	@periodeAwal date 
	,@periodeAkhir date
	,@idJenisBilling int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements. 
	Declare @Query nvarchar(max)
		   ,@Where nvarchar(max) = Case
										When @idJenisBilling <> 0
											 Then 'And a.idJenisBilling = '+ Convert(nvarchar(50), @idJenisBilling) +''
										Else 'And a.idJenisBilling In(2,4)'
									End
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @Query = 'SELECT b.idUser, b.namaLengkap
					  FROM dbo.transaksiBillingHeader a
						   Inner Join dbo.masterUser b On a.idUserBayar = b.idUser
					 WHERE Convert(date, a.tglBayar) Between '''+ Convert(nvarchar(50), @periodeAwal) +''' And '''+ Convert(nvarchar(50), @periodeAkhir) +''''+ @Where +'
				  GROUP BY b.idUser, b.namaLengkap
				  ORDER BY b.namaLengkap';
	EXEC(@Query);
END