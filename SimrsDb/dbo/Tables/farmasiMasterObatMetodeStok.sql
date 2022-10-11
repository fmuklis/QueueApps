CREATE TABLE [dbo].[farmasiMasterObatMetodeStok] (
    [idMetodeStok]   TINYINT       IDENTITY (1, 1) NOT NULL,
    [namaMetodeStok] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_farmasiMasterObatMetodeStok] PRIMARY KEY CLUSTERED ([idMetodeStok] ASC)
);

