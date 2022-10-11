CREATE TABLE [dbo].[farmasiPenjualanDetail] (
    [idPenjualanDetail]   BIGINT          IDENTITY (1, 1) NOT NULL,
    [idObatDetail]        BIGINT          NOT NULL,
    [idPenjualanHeader]   BIGINT          NULL,
    [idTindakanPasien]    BIGINT          NULL,
    [idPemakaianInternal] BIGINT          NULL,
    [idResepDetail]       BIGINT          NULL,
    [jumlah]              DECIMAL (18, 2) NOT NULL,
    [hargaPokok]          MONEY           CONSTRAINT [DF_farmasiPenjualanDetail_hargaPokok] DEFAULT ((0)) NOT NULL,
    [hargaJual]           MONEY           CONSTRAINT [DF_farmasiPenjualanDetail_hargaJual] DEFAULT ((0)) NOT NULL,
    [ditagih]             BIT             CONSTRAINT [DF_farmasiPenjualanDetail_ditagih] DEFAULT ((1)) NOT NULL,
    [idUserEntry]         INT             NULL,
    [flagPaket]           BIT             CONSTRAINT [DF_farmasiPenjualanDetail_flagPaket] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_farmasiPenjualanObat] PRIMARY KEY CLUSTERED ([idPenjualanDetail] ASC),
    CONSTRAINT [FK_farmasiPenjualanDetail_farmasiMasterObatDetail] FOREIGN KEY ([idObatDetail]) REFERENCES [dbo].[farmasiMasterObatDetail] ([idObatDetail]),
    CONSTRAINT [FK_farmasiPenjualanDetail_farmasiPemakaianInternal] FOREIGN KEY ([idPemakaianInternal]) REFERENCES [dbo].[farmasiPemakaianInternal] ([idPemakaianInternal]),
    CONSTRAINT [FK_farmasiPenjualanDetail_farmasiPenjualanHeader] FOREIGN KEY ([idPenjualanHeader]) REFERENCES [dbo].[farmasiPenjualanHeader] ([idPenjualanHeader]),
    CONSTRAINT [FK_farmasiPenjualanDetail_farmasiResepDetail] FOREIGN KEY ([idResepDetail]) REFERENCES [dbo].[farmasiResepDetail] ([idResepDetail]),
    CONSTRAINT [FK_farmasiPenjualanDetail_transaksiTindakanPasien] FOREIGN KEY ([idTindakanPasien]) REFERENCES [dbo].[transaksiTindakanPasien] ([idTindakanPasien])
);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiPenjualanDetail_idPenjualanHeader]
    ON [dbo].[farmasiPenjualanDetail]([idPenjualanHeader] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiPenjualanDetail_idObatDetail]
    ON [dbo].[farmasiPenjualanDetail]([idObatDetail] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiPenjualanDetail_idResepDetail]
    ON [dbo].[farmasiPenjualanDetail]([idResepDetail] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiPenjualanDetail_idTindakanPasien]
    ON [dbo].[farmasiPenjualanDetail]([idTindakanPasien] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiPenjualanDetail_idPemakaianInternal]
    ON [dbo].[farmasiPenjualanDetail]([idPemakaianInternal] ASC);

