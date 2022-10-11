CREATE TABLE [dbo].[farmasiMasterObatKategori] (
    [idKategoriBarang] TINYINT      NOT NULL,
    [kategoriBarang]   VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_farmasiMasterObatKategori_1] PRIMARY KEY CLUSTERED ([idKategoriBarang] ASC)
);

