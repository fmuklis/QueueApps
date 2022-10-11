CREATE TABLE [dbo].[farmasiMasterStatusPemakaianInternal] (
    [idStatusPemakaianInternal] TINYINT      NOT NULL,
    [statusPemakaianInternal]   VARCHAR (50) NOT NULL,
    [caption]                   VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_farmasiMasterStatusPemakaianInternal] PRIMARY KEY CLUSTERED ([idStatusPemakaianInternal] ASC)
);

