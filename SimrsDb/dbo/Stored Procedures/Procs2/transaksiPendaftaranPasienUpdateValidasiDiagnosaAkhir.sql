-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienUpdateValidasiDiagnosaAkhir]
	-- Add the parameters for the stored procedure here
	 @idPendaftaranPasien int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If Not Exists(Select 1 From dbo.transaksiDiagnosaPasien a
					 Inner Join dbo.masterICD b On a.idMasterICD = b.idMasterICD
			   Where idPendaftaranPasien = @idPendaftaranPasien)
		Begin
			/*Respon*/
			Select 'Tidak Dapat Divalidasi, Belum Ada Koding ICD Terhadap Diagnosa Pasien Ini' As respon, 0 As responCode;
		End
	Else
		Begin
			UPDATE dbo.transaksiPendaftaranPasien
			   SET idStatusPendaftaran = 100/*Entry Diagnosa Akhir Oleh Medrek*/
			 WHERE idPendaftaranPasien = @idPendaftaranPasien;

			/*Respon*/
			Select 'Diagnosa Akhir Divalidasi' As respon, 1 As responCode;
		End
END