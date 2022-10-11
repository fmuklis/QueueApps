CREATE TABLE [dbo].[farmasiMasterStatusStokOpname] (
    [idStatusStokOpname] TINYINT      NOT NULL,
    [statusStokOpname]   VARCHAR (50) NOT NULL,
    [caption]            VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_farmasiMasterStatusStokOpname] PRIMARY KEY CLUSTERED ([idStatusStokOpname] ASC)
);

