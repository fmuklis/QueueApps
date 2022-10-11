-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE operasi_tindakan_entryTindakan_deleteOrderIMF
	-- Add the parameters for the stored procedure here
	@idIMF int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Exists(Select 1 From dbo.farmasiIMF a
					 Inner Join dbo.farmasiResep b On a.idIMF = b.idIMF
						Inner Join dbo.farmasiPenjualanHeader ba On b.idResep = ba.idResep
						Inner Join dbo.farmasiPenjualanDetail bb On ba.idPenjualanHeader = bb.idPenjualanHeader
			   Where a.idIMF = @idIMF)
		Begin
			Select 'Tidak Dapat Dihapus, Terdapat Penjualan Resep Pada IMF Ini' As respon, 0 As responCode;
		End
	Else
		Begin
			DELETE dbo.farmasiIMF
			 WHERE idIMF = @idIMF;
			Select 'IMF Berhasil Dihapus' As respon, 1 As responCode;
		End
END