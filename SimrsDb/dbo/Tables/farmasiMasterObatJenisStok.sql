CREATE TABLE [dbo].[farmasiMasterObatJenisStok] (
    [idJenisStok]   TINYINT       IDENTITY (1, 1) NOT NULL,
    [namaJenisStok] VARCHAR (100) NOT NULL,
    [alias]         VARCHAR (50)  NULL,
    CONSTRAINT [PK_farmasiMasterOBatJenisStok] PRIMARY KEY CLUSTERED ([idJenisStok] ASC)
);

