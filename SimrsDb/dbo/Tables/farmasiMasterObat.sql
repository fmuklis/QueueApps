CREATE TABLE [dbo].[farmasiMasterObat] (
    [idObat]                         INT             IDENTITY (1, 1) NOT NULL,
    [idGolonganObat]                 INT             NULL,
    [idKategoriBarang]               TINYINT         NULL,
    [idJenisObat]                    INT             NULL,
    [namaObat]                       VARCHAR (225)   NOT NULL,
    [idJenisPenjaminInduk]           INT             NULL,
    [idSatuanObat]                   INT             NOT NULL,
    [tglEntry]                       DATETIME        CONSTRAINT [DF_farmasiMasterObat_tglEntry] DEFAULT (getdate()) NOT NULL,
    [idUserEntry]                    INT             NOT NULL,
    [kronis]                         BIT             NULL,
    [kodeObat]                       NVARCHAR (50)   NULL,
    [stokMinimalGudang]              DECIMAL (18, 2) NULL,
    [stokMinimalApotik]              DECIMAL (18, 2) NULL,
    [jumlahHariPeringatanKadaluarsa] INT             NULL,
    CONSTRAINT [PK_farmasiMasterObat] PRIMARY KEY CLUSTERED ([idObat] ASC),
    CONSTRAINT [FK_farmasiMasterObat_farmasiMasterObatGolongan] FOREIGN KEY ([idGolonganObat]) REFERENCES [dbo].[farmasiMasterObatGolongan] ([idGolonganObat]),
    CONSTRAINT [FK_farmasiMasterObat_farmasiMasterObatKategori] FOREIGN KEY ([idKategoriBarang]) REFERENCES [dbo].[farmasiMasterObatKategori] ([idKategoriBarang])
);

