CREATE TABLE [dbo].[farmasiPenghapusanStokDetail] (
    [idPenghapusanStokDetail] BIGINT          IDENTITY (1, 1) NOT NULL,
    [idPenghapusanStok]       BIGINT          NOT NULL,
    [idObatDetail]            BIGINT          NOT NULL,
    [stokAwal]                DECIMAL (18, 2) NOT NULL,
    CONSTRAINT [PK_farmasiPenghapusanStokDetail] PRIMARY KEY CLUSTERED ([idPenghapusanStokDetail] ASC),
    CONSTRAINT [FK_farmasiPenghapusanStokDetail_farmasiMasterObatDetail] FOREIGN KEY ([idObatDetail]) REFERENCES [dbo].[farmasiMasterObatDetail] ([idObatDetail]),
    CONSTRAINT [FK_farmasiPenghapusanStokDetail_farmasiPenghapusanStok] FOREIGN KEY ([idPenghapusanStok]) REFERENCES [dbo].[farmasiPenghapusanStok] ([idPenghapusanStok]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiPenghapusanStokDetail_idPenghapusanStok]
    ON [dbo].[farmasiPenghapusanStokDetail]([idPenghapusanStok] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiPenghapusanStokDetail_idObatDetail]
    ON [dbo].[farmasiPenghapusanStokDetail]([idObatDetail] ASC);

