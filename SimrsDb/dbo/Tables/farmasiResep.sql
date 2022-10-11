CREATE TABLE [dbo].[farmasiResep] (
    [idResep]             BIGINT        IDENTITY (1, 1) NOT NULL,
    [tglResep]            DATE          NOT NULL,
    [noResep]             VARCHAR (50)  NULL,
    [nomorResep]          VARCHAR (50)  NULL,
    [idIMF]               BIGINT        NULL,
    [idPendaftaranPasien] BIGINT        NULL,
    [idPasienLuar]        BIGINT        NULL,
    [idRuangan]           INT           NULL,
    [idDokter]            INT           NULL,
    [keterangan]          VARCHAR (500) NULL,
    [validationDate]      SMALLDATETIME NULL,
    [idStatusResep]       TINYINT       CONSTRAINT [DF_farmasiResep_idStatusResep] DEFAULT ((1)) NOT NULL,
    [idUserEntry]         INT           NULL,
    [tanggalEntry]        DATETIME      CONSTRAINT [DF_farmasiResep_tanggalEntry] DEFAULT (getdate()) NULL,
    [tanggalModifikasi]   DATE          NULL,
    CONSTRAINT [PK_farmasiResep] PRIMARY KEY CLUSTERED ([idResep] ASC),
    CONSTRAINT [FK_farmasiResep_farmasiIMF] FOREIGN KEY ([idIMF]) REFERENCES [dbo].[farmasiIMF] ([idIMF]) ON DELETE CASCADE,
    CONSTRAINT [FK_farmasiResep_masterOperator] FOREIGN KEY ([idDokter]) REFERENCES [dbo].[masterOperator] ([idOperator]),
    CONSTRAINT [FK_farmasiResep_masterPasienLuar] FOREIGN KEY ([idPasienLuar]) REFERENCES [dbo].[masterPasienLuar] ([idPasienLuar]),
    CONSTRAINT [FK_farmasiResep_masterRuangan] FOREIGN KEY ([idRuangan]) REFERENCES [dbo].[masterRuangan] ([idRuangan]),
    CONSTRAINT [FK_farmasiResep_masterUser] FOREIGN KEY ([idUserEntry]) REFERENCES [dbo].[masterUser] ([idUser]),
    CONSTRAINT [FK_farmasiResep_transaksiPendaftaranPasien] FOREIGN KEY ([idPendaftaranPasien]) REFERENCES [dbo].[transaksiPendaftaranPasien] ([idPendaftaranPasien]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiResep_tglResep]
    ON [dbo].[farmasiResep]([tglResep] ASC, [idStatusResep] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiResep_idIMF]
    ON [dbo].[farmasiResep]([idIMF] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiResep_idPendaftaranPasien]
    ON [dbo].[farmasiResep]([idPendaftaranPasien] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiResep_idPasienLuar]
    ON [dbo].[farmasiResep]([idPasienLuar] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiResep_idRuangan]
    ON [dbo].[farmasiResep]([idRuangan] ASC);

