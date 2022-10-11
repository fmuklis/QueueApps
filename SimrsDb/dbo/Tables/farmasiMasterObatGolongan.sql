CREATE TABLE [dbo].[farmasiMasterObatGolongan] (
    [idGolonganObat]   INT           NOT NULL,
    [namaGolonganObat] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_farmasiMasterObatKategori] PRIMARY KEY CLUSTERED ([idGolonganObat] ASC)
);

