CREATE TABLE [dbo].[farmasiStokOpname] (
    [idStokOpname]        BIGINT       IDENTITY (1, 1) NOT NULL,
    [idJenisStok]         TINYINT      NULL,
    [idRuangan]           INT          NULL,
    [idPeriodeStokOpname] INT          NOT NULL,
    [idStatusStokOpname]  TINYINT      CONSTRAINT [DF_farmasiStokOpname_idStatusStokOpname] DEFAULT ((1)) NOT NULL,
    [idPetugas]           INT          NOT NULL,
    [tanggalStokOpname]   DATE         NOT NULL,
    [kodeStokOpname]      VARCHAR (50) CONSTRAINT [DF_farmasiStokOpname_kodeStokOpname] DEFAULT ('-') NULL,
    [kodeStokOpnameBhp]   VARCHAR (50) NULL,
    [tanggalModifikasi]   DATE         NULL,
    [tanggalEntry]        DATETIME     CONSTRAINT [DF_farmasiStokOpname_tanggalEntry] DEFAULT (getdate()) NOT NULL,
    [idUserEntry]         INT          NOT NULL,
    CONSTRAINT [PK_farmasiStokOpname] PRIMARY KEY CLUSTERED ([idStokOpname] ASC),
    CONSTRAINT [FK_farmasiStokOpname_farmasiMasterObatJenisStok] FOREIGN KEY ([idJenisStok]) REFERENCES [dbo].[farmasiMasterObatJenisStok] ([idJenisStok]),
    CONSTRAINT [FK_farmasiStokOpname_farmasiMasterPeriodeStokOpname] FOREIGN KEY ([idPeriodeStokOpname]) REFERENCES [dbo].[farmasiMasterPeriodeStokOpname] ([idPeriodeStokOpname]),
    CONSTRAINT [FK_farmasiStokOpname_farmasiMasterStatusStokOpname] FOREIGN KEY ([idStatusStokOpname]) REFERENCES [dbo].[farmasiMasterStatusStokOpname] ([idStatusStokOpname]),
    CONSTRAINT [FK_farmasiStokOpname_masterRuangan] FOREIGN KEY ([idRuangan]) REFERENCES [dbo].[masterRuangan] ([idRuangan]),
    CONSTRAINT [FK_farmasiStokOpname_masterUser] FOREIGN KEY ([idUserEntry]) REFERENCES [dbo].[masterUser] ([idUser])
);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiStokOpname_idPeriodeStokOpname]
    ON [dbo].[farmasiStokOpname]([idPeriodeStokOpname] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiStokOpname_idStatusStokOpname]
    ON [dbo].[farmasiStokOpname]([idStatusStokOpname] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiStokOpname_idPetugas]
    ON [dbo].[farmasiStokOpname]([idPetugas] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiStokOpname_tanggalStokOpname]
    ON [dbo].[farmasiStokOpname]([tanggalStokOpname] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiStokOpname_idJenisStok]
    ON [dbo].[farmasiStokOpname]([idJenisStok] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiStokOpname_kodeStokOpname]
    ON [dbo].[farmasiStokOpname]([kodeStokOpname] ASC);

