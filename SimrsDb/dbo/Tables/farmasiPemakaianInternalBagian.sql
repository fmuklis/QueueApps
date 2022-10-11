CREATE TABLE [dbo].[farmasiPemakaianInternalBagian] (
    [idBagian]   INT           IDENTITY (1, 1) NOT NULL,
    [alias]      NVARCHAR (50) NOT NULL,
    [namaBagian] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_farmasiPemakaianInternalBagian] PRIMARY KEY CLUSTERED ([idBagian] ASC)
);

