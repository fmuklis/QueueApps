CREATE TABLE [dbo].[farmasiPemakaianInternal] (
    [idPemakaianInternal]       BIGINT       IDENTITY (1, 1) NOT NULL,
    [idJenisStok]               TINYINT      NOT NULL,
    [tanggalPermintaan]         DATE         NOT NULL,
    [idBagian]                  INT          NOT NULL,
    [pemohon]                   VARCHAR (50) NOT NULL,
    [idPetugas]                 INT          NULL,
    [petugas]                   VARCHAR (50) NULL,
    [kodePemakaianInternal]     VARCHAR (50) NULL,
    [idStatusPemakaianInternal] TINYINT      CONSTRAINT [DF_farmasiPemakaianInternal_idStatusPemakaianInternal] DEFAULT ((1)) NOT NULL,
    [idUserEntry]               INT          NULL,
    [tanggalEntry]              DATETIME     CONSTRAINT [DF_farmasiPemakaianInternal_tanggalEntry] DEFAULT (getdate()) NOT NULL,
    [tanggalModifikasi]         DATE         NULL,
    CONSTRAINT [PK_farmasiPemakaianInternal] PRIMARY KEY CLUSTERED ([idPemakaianInternal] ASC),
    CONSTRAINT [FK_farmasiPemakaianInternal_farmasiMasterObatJenisStok] FOREIGN KEY ([idJenisStok]) REFERENCES [dbo].[farmasiMasterObatJenisStok] ([idJenisStok]),
    CONSTRAINT [FK_farmasiPemakaianInternal_farmasiMasterPetugas] FOREIGN KEY ([idPetugas]) REFERENCES [dbo].[farmasiMasterPetugas] ([idPetugasFarmasi]),
    CONSTRAINT [FK_farmasiPemakaianInternal_farmasiMasterStatusPemakaianInternal] FOREIGN KEY ([idStatusPemakaianInternal]) REFERENCES [dbo].[farmasiMasterStatusPemakaianInternal] ([idStatusPemakaianInternal]),
    CONSTRAINT [FK_farmasiPemakaianInternal_farmasiPemakaianInternalBagian] FOREIGN KEY ([idBagian]) REFERENCES [dbo].[farmasiPemakaianInternalBagian] ([idBagian]),
    CONSTRAINT [FK_farmasiPemakaianInternal_masterUser] FOREIGN KEY ([idUserEntry]) REFERENCES [dbo].[masterUser] ([idUser])
);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiPemakaianInternal_idJenisStok]
    ON [dbo].[farmasiPemakaianInternal]([idJenisStok] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiPemakaianInternal_tanggalPermintaan]
    ON [dbo].[farmasiPemakaianInternal]([tanggalPermintaan] ASC, [idJenisStok] ASC);

