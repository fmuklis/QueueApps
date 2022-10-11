CREATE TABLE [dbo].[farmasiMutasi] (
    [idMutasi]          BIGINT        IDENTITY (1, 1) NOT NULL,
    [idJenisMutasi]     TINYINT       CONSTRAINT [DF_farmasiMutasi_idJenisMutasi] DEFAULT ((1)) NULL,
    [tanggalOrder]      DATE          NULL,
    [nomorOrder]        VARCHAR (50)  NULL,
    [idJenisStokAsal]   TINYINT       NOT NULL,
    [idJenisStokTujuan] TINYINT       NULL,
    [idRuangan]         INT           NULL,
    [tanggalEntry]      DATETIME      CONSTRAINT [DF_farmasiMutasi_tanggalEntry] DEFAULT (getdate()) NOT NULL,
    [idUserEntry]       INT           NULL,
    [idUserVerifikasi]  INT           NULL,
    [tanggalAprove]     DATE          NULL,
    [kodeMutasi]        VARCHAR (50)  CONSTRAINT [DF_farmasiMutasi_kodeMutasi] DEFAULT ('-') NOT NULL,
    [petugasPenyerahan] VARCHAR (50)  NULL,
    [petugasPenerima]   VARCHAR (50)  NULL,
    [keterangan]        VARCHAR (MAX) NULL,
    [idStatusMutasi]    TINYINT       CONSTRAINT [DF_farmasiMutasi_idStatusMutasi] DEFAULT ((1)) NULL,
    [mutasiBHP]         BIT           CONSTRAINT [DF_farmasiMutasi_mutasiBHP] DEFAULT ((0)) NULL,
    [tanggalModifikasi] DATETIME      NULL,
    CONSTRAINT [PK_farmasiMutasi] PRIMARY KEY CLUSTERED ([idMutasi] ASC),
    CONSTRAINT [FK_farmasiMutasi_farmasiMasterJenisMutasi] FOREIGN KEY ([idJenisMutasi]) REFERENCES [dbo].[farmasiMasterJenisMutasi] ([idJenisMutasi]),
    CONSTRAINT [FK_farmasiMutasi_farmasiMasterObatJenisStok] FOREIGN KEY ([idJenisStokAsal]) REFERENCES [dbo].[farmasiMasterObatJenisStok] ([idJenisStok]),
    CONSTRAINT [FK_farmasiMutasi_farmasiMasterStatusMutasi] FOREIGN KEY ([idStatusMutasi]) REFERENCES [dbo].[farmasiMasterStatusMutasi] ([idStatusMutasi]),
    CONSTRAINT [FK_farmasiMutasi_masterRuangan] FOREIGN KEY ([idRuangan]) REFERENCES [dbo].[masterRuangan] ([idRuangan]),
    CONSTRAINT [FK_farmasiMutasi_masterUser] FOREIGN KEY ([idUserEntry]) REFERENCES [dbo].[masterUser] ([idUser])
);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiMutasi_idRuangan]
    ON [dbo].[farmasiMutasi]([idRuangan] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiMutasi_idJenisStokAsal]
    ON [dbo].[farmasiMutasi]([idJenisStokAsal] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiMutasi_idJenisStokTujuan]
    ON [dbo].[farmasiMutasi]([idJenisStokTujuan] ASC);

