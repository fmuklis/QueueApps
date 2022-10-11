CREATE TABLE [dbo].[transaksiTindakanPasien] (
    [idTindakanPasien]    BIGINT          IDENTITY (1, 1) NOT NULL,
    [idPendaftaranPasien] BIGINT          NULL,
    [idOrderDetail]       BIGINT          NULL,
    [idTransaksiKonsul]   BIGINT          NULL,
    [idTransaksiOrderOK]  INT             NULL,
    [idJenisBilling]      SMALLINT        NOT NULL,
    [idRuangan]           INT             NOT NULL,
    [idMasterTarif]       INT             NOT NULL,
    [tglTindakan]         DATETIME        NOT NULL,
    [idUserEntry]         INT             NOT NULL,
    [TglEntry]            DATETIME        CONSTRAINT [DF_transaksiTindakanPasien_TglEntry] DEFAULT (getdate()) NOT NULL,
    [ditagih]             BIT             CONSTRAINT [DF_transaksiTindakanPasien_ditagih] DEFAULT ((1)) NULL,
    [qty]                 INT             CONSTRAINT [DF_transaksiTindakanPasien_qty] DEFAULT ((1)) NULL,
    [diskonTunai]         DECIMAL (18, 2) CONSTRAINT [DF_transaksiTindakanPasien_diskonTunai] DEFAULT ((0)) NOT NULL,
    [diskonPersen]        DECIMAL (18, 2) CONSTRAINT [DF_transaksiTindakanPasien_diskonPersen] DEFAULT ((0)) NOT NULL,
    [flagPaket]           BIT             CONSTRAINT [DF_transaksiTindakanPasien_flagPaket] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_transaksiTindakanPasien] PRIMARY KEY CLUSTERED ([idTindakanPasien] ASC),
    CONSTRAINT [FK_transaksiTindakanPasien_masterRuangan] FOREIGN KEY ([idRuangan]) REFERENCES [dbo].[masterRuangan] ([idRuangan]) ON UPDATE CASCADE,
    CONSTRAINT [FK_transaksiTindakanPasien_masterTarip] FOREIGN KEY ([idMasterTarif]) REFERENCES [dbo].[masterTarip] ([idMasterTarif]) ON UPDATE CASCADE,
    CONSTRAINT [FK_transaksiTindakanPasien_transaksiKonsul] FOREIGN KEY ([idTransaksiKonsul]) REFERENCES [dbo].[transaksiKonsul] ([idTransaksiKonsul]),
    CONSTRAINT [FK_transaksiTindakanPasien_transaksiOrderDetail] FOREIGN KEY ([idOrderDetail]) REFERENCES [dbo].[transaksiOrderDetail] ([idOrderDetail]) ON DELETE CASCADE,
    CONSTRAINT [FK_transaksiTindakanPasien_transaksiOrderOK] FOREIGN KEY ([idTransaksiOrderOK]) REFERENCES [dbo].[transaksiOrderOK] ([idTransaksiOrderOK]),
    CONSTRAINT [FK_transaksiTindakanPasien_transaksiTindakanPasien] FOREIGN KEY ([idPendaftaranPasien]) REFERENCES [dbo].[transaksiPendaftaranPasien] ([idPendaftaranPasien])
);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiTindakanPasien_idMasterTarif]
    ON [dbo].[transaksiTindakanPasien]([idMasterTarif] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiTindakanPasien_idPendaftaranPasien]
    ON [dbo].[transaksiTindakanPasien]([idPendaftaranPasien] ASC, [idJenisBilling] ASC, [idRuangan] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiTindakanPasien_idTransaksiOrderOK]
    ON [dbo].[transaksiTindakanPasien]([idTransaksiOrderOK] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiTindakanPasien_idOrderDetail]
    ON [dbo].[transaksiTindakanPasien]([idOrderDetail] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiTindakanPasien_idTransaksiKonsul]
    ON [dbo].[transaksiTindakanPasien]([idTransaksiKonsul] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiTindakanPasien_idRuangan]
    ON [dbo].[transaksiTindakanPasien]([idRuangan] ASC);

