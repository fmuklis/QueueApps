CREATE TABLE [dbo].[masterPasien] (
    [idPasien]                 BIGINT          IDENTITY (1, 1) NOT NULL,
    [kodePasien]               NCHAR (20)      NOT NULL,
    [namaLengkapPasien]        VARCHAR (100)   NOT NULL,
    [gelarDepanPasien]         VARCHAR (50)    NULL,
    [gelarBelakangPasien]      VARCHAR (50)    NULL,
    [idPekerjaanPasien]        TINYINT         NOT NULL,
    [tempatLahirPasien]        VARCHAR (50)    NOT NULL,
    [tglLahirPasien]           DATE            NOT NULL,
    [idJenisKelaminPasien]     TINYINT         NOT NULL,
    [alamatPasien]             VARCHAR (250)   NOT NULL,
    [idDesaKelurahanPasien]    INT             NOT NULL,
    [namaAyahPasien]           VARCHAR (50)    NOT NULL,
    [namaIbuPasien]            VARCHAR (50)    NULL,
    [anakKePasien]             TINYINT         NULL,
    [idDokumenIdentitasPasien] TINYINT         NOT NULL,
    [noDokumenIdentitasPasien] VARCHAR (50)    NULL,
    [idPendidikanPasien]       TINYINT         NOT NULL,
    [idAgamaPasien]            TINYINT         NOT NULL,
    [idWargaNegaraPasien]      TINYINT         NOT NULL,
    [noHpPasien1]              VARCHAR (50)    NULL,
    [noHPPasien2]              VARCHAR (50)    NULL,
    [idStatusPerkawinanPasien] TINYINT         NOT NULL,
    [catatanKesehatan]         VARCHAR (MAX)   NULL,
    [jumlahCetak]              TINYINT         CONSTRAINT [DF_masterPasien_jumlahCetak] DEFAULT ((0)) NOT NULL,
    [cetakKartu]               BIT             NULL,
    [noBPJS]                   VARCHAR (50)    NULL,
    [beratLahir]               DECIMAL (18, 2) NULL,
    [entryDate]                SMALLDATETIME   NULL,
    CONSTRAINT [PK_masterPasien] PRIMARY KEY CLUSTERED ([idPasien] ASC),
    CONSTRAINT [FK_masterPasien_masterAgamaPasien] FOREIGN KEY ([idAgamaPasien]) REFERENCES [dbo].[masterAgama] ([idAgama]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_masterPasien_masterDesaKelurahanPasien] FOREIGN KEY ([idDesaKelurahanPasien]) REFERENCES [dbo].[masterDesaKelurahan] ([idDesaKelurahan]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_masterPasien_masterDokumenIdentitasPasien] FOREIGN KEY ([idDokumenIdentitasPasien]) REFERENCES [dbo].[masterDokumenIdentitas] ([idDokumenIdentitas]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_masterPasien_masterJenisKelaminPasien] FOREIGN KEY ([idJenisKelaminPasien]) REFERENCES [dbo].[masterJenisKelamin] ([idJenisKelamin]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_masterPasien_masterPekerjaanPasien] FOREIGN KEY ([idPekerjaanPasien]) REFERENCES [dbo].[masterPekerjaan] ([idPekerjaan]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_masterPasien_masterPendidikan] FOREIGN KEY ([idPendidikanPasien]) REFERENCES [dbo].[masterPendidikan] ([idPendidikan]) ON UPDATE CASCADE,
    CONSTRAINT [FK_masterPasien_masterStatusPerkawinanPasien] FOREIGN KEY ([idStatusPerkawinanPasien]) REFERENCES [dbo].[masterStatusPerkawinan] ([idStatusPerkawinan]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_masterPasien_masterWargaNegaraPasien] FOREIGN KEY ([idWargaNegaraPasien]) REFERENCES [dbo].[masterWargaNegara] ([idWargaNegara]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_kodePasien]
    ON [dbo].[masterPasien]([kodePasien] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_namaLengkapPasien]
    ON [dbo].[masterPasien]([namaLengkapPasien] ASC, [tglLahirPasien] ASC, [alamatPasien] ASC);

