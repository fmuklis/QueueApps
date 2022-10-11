-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		Start-X
-- Create date: 15-10-2018
-- Description:	Insert To Master Ruangan & Master Ruangan Pelayanan
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[masterRuangan_Update] 
	-- Add the parameters for the stored procedure here

	--Master Ruangan
	 @idRuangan int
	,@namaRuangan nvarchar(50)
	,@idJenisRuangan int
	--Master Ruangan Pelayanan
	,@idMasterPelayanan int
	,@checked bit

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	
	SET NOCOUNT ON;   
		
			If Exists ( Select 1 From [masterRuangan] Where idRuangan = @idRuangan)	
				Begin
					If Not Exists ( Select 1 From [masterRuangan] Where namaRuangan = @namaRuangan and idRuangan! = @idRuangan)
						Begin			
							UPDATE [dbo].[masterRuangan]
							SET	 [namaRuangan] = UPPER(@namaRuangan)
								,[idJenisRuangan] = @idJenisRuangan	where idRuangan = @idRuangan;
								
								if @checked = 0
								Begin
									delete from masterRuanganPelayanan where idRuangan = @idRuangan and idMasterPelayanan = @idMasterPelayanan;
								End
								else
								BEGIN 
									If not exists(Select 1 from masterRuanganPelayanan where idRuangan = @idRuangan and idMasterPelayanan = @idMasterPelayanan)
									Begin	
										If @idMasterPelayanan! = 0
										Begin
											INSERT INTO [dbo].[masterRuanganPelayanan]
														([idMasterPelayanan],idRuangan)
												VALUES (@idMasterPelayanan,@idRuangan);
										End
									End
								END

									Select 'Data berhasil diupdate' as respon,1 as responCode;
								End
								else
								Begin
									
									Select 'Nama Ruangan Sudah ada' as respon,0 as responCode;
								End

						End
									
			
END