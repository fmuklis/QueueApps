CREATE TABLE [dbo].[farmasiMasterPetugas] (
    [idPetugasFarmasi]   INT           IDENTITY (1, 1) NOT NULL,
    [namaPetugasFarmasi] NVARCHAR (50) NULL,
    CONSTRAINT [PK_farmasiMasterPetugas] PRIMARY KEY CLUSTERED ([idPetugasFarmasi] ASC)
);

