CREATE TABLE [dbo].[farmasiPenghapusanStok] (
    [idPenghapusanStok]   BIGINT       IDENTITY (1, 1) NOT NULL,
    [tanggalPenghapusan]  DATE         NOT NULL,
    [kodePenghapusan]     VARCHAR (50) CONSTRAINT [DF_farmasiPenghapusanStok_kodePenghapusan] DEFAULT ('-') NOT NULL,
    [idStatusPenghapusan] TINYINT      CONSTRAINT [DF_farmasiPenghapusanStok_idStatusPenghapusan] DEFAULT ((1)) NOT NULL,
    [idPetugas]           INT          NOT NULL,
    [idUserEntry]         INT          NOT NULL,
    [tanggalEntry]        DATETIME     CONSTRAINT [DF_farmasiPenghapusanStok_tanggalEntry] DEFAULT (getdate()) NOT NULL,
    [tanggalModifikasi]   DATE         NULL,
    CONSTRAINT [PK_farmasiPenghapusanStok] PRIMARY KEY CLUSTERED ([idPenghapusanStok] ASC),
    CONSTRAINT [FK_farmasiPenghapusanStok_farmasiMasterPetugas] FOREIGN KEY ([idPetugas]) REFERENCES [dbo].[farmasiMasterPetugas] ([idPetugasFarmasi]),
    CONSTRAINT [FK_farmasiPenghapusanStok_farmasiMasterStatusPenghapusan] FOREIGN KEY ([idStatusPenghapusan]) REFERENCES [dbo].[farmasiMasterStatusPenghapusan] ([idStatusPenghapusan]),
    CONSTRAINT [FK_farmasiPenghapusanStok_masterUser] FOREIGN KEY ([idUserEntry]) REFERENCES [dbo].[masterUser] ([idUser])
);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiPenghapusanStok_tanggalPenghapusan]
    ON [dbo].[farmasiPenghapusanStok]([tanggalPenghapusan] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiPenghapusanStok_kodePenghapusan]
    ON [dbo].[farmasiPenghapusanStok]([kodePenghapusan] ASC);

