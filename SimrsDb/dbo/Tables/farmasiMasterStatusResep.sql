CREATE TABLE [dbo].[farmasiMasterStatusResep] (
    [idStatusResep] TINYINT      NOT NULL,
    [statusResep]   VARCHAR (50) NOT NULL,
    [caption]       VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_farmasiMasterStatusResep] PRIMARY KEY CLUSTERED ([idStatusResep] ASC)
);

