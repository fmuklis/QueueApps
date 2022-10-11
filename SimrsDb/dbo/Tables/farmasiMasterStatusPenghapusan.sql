CREATE TABLE [dbo].[farmasiMasterStatusPenghapusan] (
    [idStatusPenghapusan] TINYINT      NOT NULL,
    [statusPenghapusan]   VARCHAR (50) NOT NULL,
    [caption]             VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_farmasiMasterStatusPenghapusan] PRIMARY KEY CLUSTERED ([idStatusPenghapusan] ASC)
);

