CREATE TABLE [dbo].[farmasiMasterObatDetail] (
    [idObatDetail]            BIGINT          IDENTITY (1, 1) NOT NULL,
    [idMetodeStok]            TINYINT         NULL,
    [idJenisStok]             TINYINT         NULL,
    [idRuangan]               INT             NULL,
    [idObatDosis]             INT             NULL,
    [kodeBatch]               VARCHAR (50)    NOT NULL,
    [tglExpired]              DATE            CONSTRAINT [DF_farmasiMasterObatDetail_tglExpired] DEFAULT (getdate()) NOT NULL,
    [tglStokAtauTglBeli]      DATE            NOT NULL,
    [stok]                    DECIMAL (18, 2) NOT NULL,
    [hargaPokok]              MONEY           NULL,
    [idPembelianDetail]       BIGINT          NULL,
    [idMutasiRequestApproved] BIGINT          NULL,
    [idStokOpnameDetail]      BIGINT          NULL,
    [idObatDetailAsal]        BIGINT          NULL,
    [tanggalEntry]            DATETIME        CONSTRAINT [DF_farmasiMasterObatDetail_tanggalEntry] DEFAULT (getdate()) NOT NULL,
    [idUserEntry]             INT             NOT NULL,
    CONSTRAINT [PK_farmasiMasterObatDetail] PRIMARY KEY CLUSTERED ([idObatDetail] ASC),
    CONSTRAINT [FK_farmasiMasterObatDetail_farmasiMasterObatDosis] FOREIGN KEY ([idObatDosis]) REFERENCES [dbo].[farmasiMasterObatDosis] ([idObatDosis]),
    CONSTRAINT [FK_farmasiMasterOBatDetail_farmasiMasterOBatJenisStok] FOREIGN KEY ([idJenisStok]) REFERENCES [dbo].[farmasiMasterObatJenisStok] ([idJenisStok]),
    CONSTRAINT [FK_farmasiMasterObatDetail_farmasiMasterObatMetodeStok] FOREIGN KEY ([idMetodeStok]) REFERENCES [dbo].[farmasiMasterObatMetodeStok] ([idMetodeStok]),
    CONSTRAINT [FK_farmasiMasterObatDetail_farmasiMutasiRequestApproved] FOREIGN KEY ([idMutasiRequestApproved]) REFERENCES [dbo].[farmasiMutasiRequestApproved] ([idMutasiRequestApproved]),
    CONSTRAINT [FK_farmasiMasterObatDetail_farmasiStokOpnameDetail] FOREIGN KEY ([idStokOpnameDetail]) REFERENCES [dbo].[farmasiStokOpnameDetail] ([idStokOpnameDetail]),
    CONSTRAINT [FK_farmasiMasterObatDetail_masterRuangan] FOREIGN KEY ([idRuangan]) REFERENCES [dbo].[masterRuangan] ([idRuangan]),
    CONSTRAINT [FK_farmasiMasterObatDetail_masterUser] FOREIGN KEY ([idUserEntry]) REFERENCES [dbo].[masterUser] ([idUser])
);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiMasterObatDetail_idJenisStok]
    ON [dbo].[farmasiMasterObatDetail]([idJenisStok] ASC)
    INCLUDE([tglExpired], [stok]);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiMasterObatDetail_idRuangan]
    ON [dbo].[farmasiMasterObatDetail]([idRuangan] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiMasterObatDetail_idObatDosis]
    ON [dbo].[farmasiMasterObatDetail]([idObatDosis] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiMasterObatDetail_idPembelianDetail]
    ON [dbo].[farmasiMasterObatDetail]([idPembelianDetail] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiMasterObatDetail_idMutasiRequestApproved]
    ON [dbo].[farmasiMasterObatDetail]([idMutasiRequestApproved] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiMasterObatDetail_idStokOpnameDetail]
    ON [dbo].[farmasiMasterObatDetail]([idStokOpnameDetail] ASC);


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[generate_logDeleted] 
   ON dbo.farmasiMasterObatDetail
AFTER DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*Make Variable*/
    DECLARE @ExecStr varchar(50);

    DECLARE @inputbuffer table (EventType nvarchar(max), Parameters int, EventInfo nvarchar(max));

	/*SET Variable Value*/
    SET @ExecStr = 'DBCC INPUTBUFFER(' + STR(@@SPID) + ') with NO_INFOMSGS'

    INSERT INTO @inputbuffer
           EXEC (@ExecStr);

	/*Add Log Data*/
	INSERT INTO dbo.farmasiLogStock
			   ([idObatDetail]
			   ,[action]
			   ,[query]
			   ,[logData])
		 SELECT a.idObatDetail
			   ,'delete'
			   ,b.EventInfo
			   ,(SELECT idPembelianDetail, idMutasiRequestApproved, idStokOpnameDetail
					   ,idObatDetailAsal, stok
			   FOR JSON PATH)
		  FROM deleted a
			   OUTER APPLY @inputbuffer b
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[generate_logUpdated] 
    ON dbo.farmasiMasterObatDetail
 AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*Make Variable*/
    DECLARE @ExecStr varchar(50);

    DECLARE @inputbuffer table (EventType nvarchar(max), Parameters int, EventInfo nvarchar(max));

	/*SET Variable Value*/
    SET @ExecStr = 'DBCC INPUTBUFFER(' + STR(@@SPID) + ') with NO_INFOMSGS'

    INSERT INTO @inputbuffer
           EXEC (@ExecStr);

	WITH dataSet AS (
		SELECT 1 AS id, idObatDetail, idPembelianDetail, idMutasiRequestApproved
			  ,idStokOpnameDetail, idObatDetailAsal, stok
		  FROM deleted
		 UNION ALL
		SELECT 2 AS id, idObatDetail, idPembelianDetail, idMutasiRequestApproved
			  ,idStokOpnameDetail, idObatDetailAsal, stok
		  FROM inserted)

	/*Add Log Data*/
	INSERT INTO dbo.farmasiLogStock
			   ([idObatDetail]
			   ,[action]
			   ,[query]
			   ,[logData])
		 SELECT idObatDetail
			   ,'update'
			   ,c.EventInfo
			   ,JSON_QUERY('['+ STRING_AGG(b.logData, ',') +']')
		  FROM dataSet a
			   OUTER APPLY (SELECT TRIM('[]' FROM (SELECT idPembelianDetail, idMutasiRequestApproved, idStokOpnameDetail, idObatDetailAsal, stok FOR JSON PATH)) AS logData
							  FROM dataSet xa
							 WHERE xa.id = a.id) b
			   OUTER APPLY @inputbuffer c
	  GROUP BY idObatDetail, c.EventInfo
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[generate_logInserted] 
    ON dbo.farmasiMasterObatDetail
 AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*Make Variable*/
    DECLARE @ExecStr varchar(50);

    DECLARE @inputbuffer table (EventType nvarchar(max), Parameters int, EventInfo nvarchar(max));

	/*SET Variable Value*/
    SET @ExecStr = 'DBCC INPUTBUFFER(' + STR(@@SPID) + ') with NO_INFOMSGS'

    INSERT INTO @inputbuffer
           EXEC (@ExecStr);

	/*Add Log Data*/
	INSERT INTO dbo.farmasiLogStock
			   ([idObatDetail]
			   ,[action]
			   ,[query]
			   ,[logData])
		 SELECT a.idObatDetail
			   ,'insert'
			   ,b.EventInfo
			   ,(SELECT idPembelianDetail, idMutasiRequestApproved, idStokOpnameDetail
					   ,idObatDetailAsal, stok
			   FOR JSON PATH)
		  FROM inserted a
			   OUTER APPLY @inputbuffer b
END