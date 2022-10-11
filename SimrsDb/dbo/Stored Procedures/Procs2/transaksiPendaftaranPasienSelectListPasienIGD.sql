-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
CREATE PROCEDURE [dbo].[transaksiPendaftaranPasienSelectListPasienIGD]
	-- Add the parameters for the stored procedure here
	@start nchar(4),
	@length nchar(4),
	@search varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
    DECLARE @jmlData int = (Select Count(idPendaftaranPasien) 
							  From dbo.transaksiPendaftaranPasien xa
								   Inner Join dbo.masterJenisPenjaminPembayaranPasien xb On xa.idJenisPenjaminPembayaranPasien = xb.idJenisPenjaminPembayaranPasien
							 Where xa.idJenisPendaftaran = 1 And xa.idJenisPerawatan = 2 And (xa.idStatusPendaftaran In(2,3,4,98) Or (xa.idStatusPendaftaran > = 99 And xb.idJenisPenjaminInduk = 2/*BPJS*/ And Convert(date, xa.tglDaftarPasien) = Convert(date, GetDate()))))
		   ,@Query NVARCHAR(MAX)
		   ,@ParmDefinition nvarchar(MAX)
		   ,@Where NVARCHAR(MAX) = Case
										When @search Is Not Null
											 Then 'And (noRM like ''%''+@filter+''%'' Or namaPasien like ''%''+@filter+''%'' Or kodePasien like ''%''+@filter+''%'')'
										Else ''
									End
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @Query = 'SELECT a.idPendaftaranPasien, a.tglDaftarPasien, b.noRM, b.namaPasien, ca.namaJenisPenjaminInduk
						,ROW_NUMBER() OVER (ORDER BY a.tglDaftarPasien) As id
						,Case
							  When Exists(Select 1 From dbo.transaksiTindakanPasien xa Where a.idPendaftaranPasien = xa.idPendaftaranPasien)
								   Then 1
							  Else 0
						  End As flagTindakan
						,Case
							  When a.idStatusPendaftaran In(2,3) And d.idTransaksiOrderOK is Null
								   Then 1
							  Else 0
						  End As btnEntryTindakan
						,Case
							  When a.idStatusPendaftaran In(2,3) And d.idTransaksiOrderOK is Null
								   Then 1
							  Else 0
						  End As btnBtlTerima
						,Case
							  When a.idStatusPendaftaran = 4
								   Then 1
							  Else 0
						  End As btnBtlOrderRaNap
						,Case
							  When d.idTransaksiOrderOK is Null
								   Then 0
							  Else 1
						  End As btnBtlOk
						,Case
							  When a.idStatusPendaftaran = 98
								   Then 1
							  Else 0
						  End As btnBtlBilling
						,Case
							  When a.idStatusPendaftaran = 99 And c.idJenisPenjaminInduk = 2/*BPJS*/
								   Then 1
							  Else 0
						  End As btnBtlPulang
						,'+ Convert(nvarchar(50), @jmlData) +' As jumlahData
					FROM dbo.transaksiPendaftaranPasien a
						 Inner Join dbo.dataPasien() b On a.idPasien = b.idPasien
						 Inner Join dbo.masterJenisPenjaminPembayaranPasien c On a.idJenisPenjaminPembayaranPasien = c.idJenisPenjaminPembayaranPasien
								Inner Join dbo.masterJenisPenjaminPembayaranPasienInduk ca On c.idJenisPenjaminInduk = ca.idJenisPenjaminInduk
						 Left Join dbo.transaksiOrderOK d On a.idPendaftaranPasien = d.idPendaftaranPasien
				   WHERE a.idJenisPendaftaran = 1 And a.idJenisPerawatan = 2 And (a.idStatusPendaftaran In(2,3,4,98) Or (a.idStatusPendaftaran > = 99 And c.idJenisPenjaminInduk = 2/*BPJS*/ And Convert(date, a.tglDaftarPasien) = Convert(date, GetDate()))) @dynamic
				 ORDER BY tglDaftarPasien
				   OFFSET '+ @start +' ROWS 
			   FETCH NEXT '+ @length +' ROWS ONLY;';

	SET @Query = Replace(@Query, '@dynamic', @Where);
	SET @ParmDefinition = N' @filter nvarchar(50)';
	EXEC sp_executesql  @Query, @ParmDefinition, @filter = @search;
END