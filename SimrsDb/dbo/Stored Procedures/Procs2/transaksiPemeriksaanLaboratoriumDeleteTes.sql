-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[transaksiPemeriksaanLaboratoriumDeleteTes]
	-- Add the parameters for the stored procedure here
	 @idOrder int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*DECLARE  @idTransaksi table(idOrderDetail int, idPendaftaranPasien int, idMasterTarif int);
		Insert Into @idTransaksi
		Select a.idOrderDetail ,a.idPendaftaranPasien ,b.idMasterTarif  
		  From dbo.transaksiPemeriksaanLaboratorium a Inner Join transaksiOrderDetail b On a.idOrderDetail = b.idOrderDetail
		 Where b.idOrder = @idOrder
	  Group By a.idOrderDetail ,a.idPendaftaranPasien ,b.idMasterTarif;

    -- Insert statements for procedure here
	If Exists (Select Top 1 1 From transaksiPemeriksaanLaboratorium Where [idOrderDetail] In (Select idOrderDetail From @idTransaksi))
		Begin
			Begin Tran tranPemeriksaanLaboratoriumDel;
			Begin Try
					DELETE FROM [dbo].[transaksiPemeriksaanLaboratorium]
						  WHERE idOrderDetail In (Select idOrderDetail From @idTransaksi);

					DELETE FROM [dbo].[transaksiTindakanPasien]
						  WHERE idPendaftaranPasien In (Select Distinct idPendaftaranPasien From @idTransaksi) And idMasterTarif In (Select idMasterTarif From @idTransaksi);

					Update transaksiOrder Set idStatusOrder = 1 Where idOrder = @idOrder; 

				Commit Tran tranPemeriksaanLaboratoriumDel;
				SELECT 'Data Berhasil Dihapus' as respon, 1 as responCode;
			End Try
			Begin Catch
				Rollback Tran tranPemeriksaanLaboratoriumDel;
				SELECT 'Error !' + ERROR_MESSAGE() as respon, 0 as responCode;
			End Catch
		End
	Else
		Begin
			SELECT 'Data Tidak Ditemukan' as respon, 0 as responCode;
		End*/ 
END