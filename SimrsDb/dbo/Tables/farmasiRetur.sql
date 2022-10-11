CREATE TABLE [dbo].[farmasiRetur] (
    [idRetur]           BIGINT        IDENTITY (1, 1) NOT NULL,
    [tanggalRetur]      DATE          NOT NULL,
    [kodeRetur]         VARCHAR (50)  NULL,
    [idJenisRetur]      TINYINT       CONSTRAINT [DF_farmasiRetur_idJenisRetur] DEFAULT ((1)) NOT NULL,
    [idJenisStokAsal]   TINYINT       NULL,
    [idJenisStokTujuan] TINYINT       NULL,
    [keterangan]        VARCHAR (500) NULL,
    [idPetugasRetur]    INT           NULL,
    [idPenerima]        INT           NULL,
    [idStatusRetur]     TINYINT       CONSTRAINT [DF_farmasiRetur_idStatusRetur] DEFAULT ((1)) NOT NULL,
    [idUserEntry]       INT           NOT NULL,
    [tanggalEntry]      DATETIME      CONSTRAINT [DF_farmasiRetur_tanggalEntry] DEFAULT (getdate()) NOT NULL,
    [tanggalModifikasi] DATE          NULL,
    CONSTRAINT [PK_farmasiRetur] PRIMARY KEY CLUSTERED ([idRetur] ASC),
    CONSTRAINT [FK_farmasiRetur_farmasiMasterJenisRetur] FOREIGN KEY ([idJenisRetur]) REFERENCES [dbo].[farmasiMasterJenisRetur] ([idJenisRetur]),
    CONSTRAINT [FK_farmasiRetur_farmasiMasterObatJenisStok] FOREIGN KEY ([idJenisStokAsal]) REFERENCES [dbo].[farmasiMasterObatJenisStok] ([idJenisStok]),
    CONSTRAINT [FK_farmasiRetur_farmasiMasterObatJenisStok1] FOREIGN KEY ([idJenisStokTujuan]) REFERENCES [dbo].[farmasiMasterObatJenisStok] ([idJenisStok]),
    CONSTRAINT [FK_farmasiRetur_farmasiMasterPetugas] FOREIGN KEY ([idPetugasRetur]) REFERENCES [dbo].[farmasiMasterPetugas] ([idPetugasFarmasi]),
    CONSTRAINT [FK_farmasiRetur_farmasiMasterPetugas1] FOREIGN KEY ([idPenerima]) REFERENCES [dbo].[farmasiMasterPetugas] ([idPetugasFarmasi]),
    CONSTRAINT [FK_farmasiRetur_farmasiMasterStatusRetur] FOREIGN KEY ([idStatusRetur]) REFERENCES [dbo].[farmasiMasterStatusRetur] ([idStatusRetur])
);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiRetur_idJenisRetur]
    ON [dbo].[farmasiRetur]([idJenisRetur] ASC, [idStatusRetur] ASC, [tanggalRetur] ASC, [idJenisStokTujuan] ASC, [idJenisStokAsal] ASC);

