CREATE TABLE [dbo].[farmasiJurnalStok] (
    [idLog]                   BIGINT          IDENTITY (1, 1) NOT NULL,
    [idObatDetail]            BIGINT          NOT NULL,
    [idPembelianDetail]       BIGINT          NULL,
    [idPenjualanDetail]       BIGINT          NULL,
    [idPemakaianInternal]     BIGINT          NULL,
    [idMutasiRequestApproved] BIGINT          NULL,
    [idStokOpnameDetail]      BIGINT          NULL,
    [idReturDetail]           BIGINT          NULL,
    [idPenghapusanStokDetail] BIGINT          NULL,
    [stokAwal]                DECIMAL (18, 2) CONSTRAINT [DF_farmasiJurnalStok_stokAwal] DEFAULT ((0)) NOT NULL,
    [jumlahKeluar]            DECIMAL (18, 2) CONSTRAINT [DF_farmasiJurnalStok_jumlahKeluar] DEFAULT ((0)) NOT NULL,
    [jumlahMasuk]             DECIMAL (18, 2) CONSTRAINT [DF_farmasiJurnalStok_jumlahMasuk] DEFAULT ((0)) NOT NULL,
    [stokAkhir]               DECIMAL (18, 2) CONSTRAINT [DF_farmasiJurnalStok_stokAkhir] DEFAULT ((0)) NOT NULL,
    [tanggalEntry]            DATETIME        CONSTRAINT [DF_farmasiJurnalStok_tanggalEntry] DEFAULT (getdate()) NOT NULL,
    [idUserEntry]             INT             NOT NULL,
    CONSTRAINT [PK_farmasiJurnalStok] PRIMARY KEY CLUSTERED ([idLog] ASC),
    CONSTRAINT [FK_farmasiJurnalStok_farmasiMasterObatDetail] FOREIGN KEY ([idObatDetail]) REFERENCES [dbo].[farmasiMasterObatDetail] ([idObatDetail]) ON DELETE CASCADE,
    CONSTRAINT [FK_farmasiJurnalStok_farmasiMutasiRequestApproved] FOREIGN KEY ([idMutasiRequestApproved]) REFERENCES [dbo].[farmasiMutasiRequestApproved] ([idMutasiRequestApproved]),
    CONSTRAINT [FK_farmasiJurnalStok_farmasiPemakaianInternal] FOREIGN KEY ([idPemakaianInternal]) REFERENCES [dbo].[farmasiPemakaianInternal] ([idPemakaianInternal]),
    CONSTRAINT [FK_farmasiJurnalStok_farmasiPembelianDetail] FOREIGN KEY ([idPembelianDetail]) REFERENCES [dbo].[farmasiPembelianDetail] ([idPembelianDetail]),
    CONSTRAINT [FK_farmasiJurnalStok_farmasiPenghapusanStokDetail] FOREIGN KEY ([idPenghapusanStokDetail]) REFERENCES [dbo].[farmasiPenghapusanStokDetail] ([idPenghapusanStokDetail]),
    CONSTRAINT [FK_farmasiJurnalStok_farmasiPenjualanDetail] FOREIGN KEY ([idPenjualanDetail]) REFERENCES [dbo].[farmasiPenjualanDetail] ([idPenjualanDetail]),
    CONSTRAINT [FK_farmasiJurnalStok_farmasiRetur] FOREIGN KEY ([idReturDetail]) REFERENCES [dbo].[farmasiReturDetail] ([idReturDetail]),
    CONSTRAINT [FK_farmasiJurnalStok_farmasiStokOpnameDetail] FOREIGN KEY ([idStokOpnameDetail]) REFERENCES [dbo].[farmasiStokOpnameDetail] ([idStokOpnameDetail]),
    CONSTRAINT [FK_farmasiJurnalStok_masterUser] FOREIGN KEY ([idUserEntry]) REFERENCES [dbo].[masterUser] ([idUser])
);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiJurnalStok_idMutasiDetail]
    ON [dbo].[farmasiJurnalStok]([idMutasiRequestApproved] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiJurnalStok_idObatDetail]
    ON [dbo].[farmasiJurnalStok]([idObatDetail] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiJurnalStok_idPemakaianInternal]
    ON [dbo].[farmasiJurnalStok]([idPemakaianInternal] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiJurnalStok_idPembelianDetail]
    ON [dbo].[farmasiJurnalStok]([idPembelianDetail] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiJurnalStok_idPenjualanDetail]
    ON [dbo].[farmasiJurnalStok]([idPenjualanDetail] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiJurnalStok_idRetur]
    ON [dbo].[farmasiJurnalStok]([idReturDetail] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiJurnalStok_tglEntry]
    ON [dbo].[farmasiJurnalStok]([tanggalEntry] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiJurnalStok_idPenghapusanStokDetail]
    ON [dbo].[farmasiJurnalStok]([idPenghapusanStokDetail] ASC);

