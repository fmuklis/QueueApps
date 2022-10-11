-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author     :	komar
-- Create date: <Create Date,,>
-- Description:	
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[operasi_tindakan_dashboard_listRequest_jadwalOperasiAdd]	
	-- Add the parameters for the stored procedure here
	@idUser int,
	@idTransaksiOrderOk int,
	@tglOperasi smalldatetime,
	@idOperator int,
	@idGolonganOperasi int,
	@idJenisSpesialis int,
	@rencanaTindakan varchar(255),
	@waDokter varchar(15),
	@waPasien varchar(15)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


    -- Insert statements for procedure here
	IF (@tglOperasi < CAST(GETDATE() AS smalldatetime))
		BEGIN
            SELECT 'Tanggal operasi tidak boleh kurang dari tanggal pada hari ini.' AS respon, 0 AS responCode;
		END
            
    ELSE
        BEGIN TRY  
            /*Transaction Begin*/
            BEGIN TRAN;

			/*update transaksi*/
			UPDATE dbo.transaksiOrderOK
			   SET tglJadwal = @tglOperasi
				  ,idOperator = @idOperator
				  ,idGolonganOk = @idGolonganOperasi
				  ,idGolonganSpesialis = @idJenisSpesialis
				  ,rencanaTindakan = @rencanaTindakan
				  ,kodeoBooking = NEWID()
			 WHERE idTransaksiOrderOK = @idTransaksiOrderOk;

			 /*update wa operator*/
			 UPDATE dbo.masterOperator
				SET hp = @waDokter
			  WHERE idOperator = @idOperator;

			  /*update wa pasien*/
			  UPDATE a
				 SET a.noHpPasien1 = @waPasien
			    FROM dbo.masterPasien a 
					 INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPasien = b.idPasien
				     INNER JOIN dbo.transaksiOrderOK c ON b.idPendaftaranPasien = c.idPendaftaranPasien
			   WHERE c.idTransaksiOrderOK = @idTransaksiOrderOk;

            /*Transaction Commit*/
            COMMIT TRAN;

            SELECT 'Jadwal Operasi berhasil disimpan.' AS respon, 1 AS responCode
				   ,ba.idPasien ,ba.namaPasien, ba.noHpPasien1 AS waPasien
				   ,c.NamaOperator, c.hp AS waDokter, d.namaRumahSakit, d.namaPendekRumahSakit
				   ,a.tglJadwal, a.rencanaTindakan, aa.golonganOk, ab.golonganSpesialis
			  FROM dbo.transaksiOrderOK a 
				   LEFT JOIN dbo.masterOkGolongan aa ON a.idGolonganOk = aa.idGolonganOk
				   LEFT JOIN dbo.masterOkGolonganSpesialis ab ON a.idGolonganSpesialis = ab.idGolonganSpesialis 
				   INNER JOIN dbo.transaksiPendaftaranPasien b ON a.idPendaftaranPasien = b.idPendaftaranPasien
						OUTER APPLY dbo.getInfo_dataPasien(b.idPasien) ba
				   INNER JOIN dbo.masterOperator c ON a.idOperator = c.idOperator
				   OUTER APPLY dbo.masterRumahSakit d
			 WHERE a.idTransaksiOrderOK = @idTransaksiOrderOk;
        END TRY  
        BEGIN CATCH  
            /*Transaction Rollback*/
            ROLLBACK TRAN;
            SELECT 'Error!: '+ ERROR_MESSAGE() AS respon, 2 AS responCode;
        END CATCH  
    

END