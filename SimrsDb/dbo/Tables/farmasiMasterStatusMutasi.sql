CREATE TABLE [dbo].[farmasiMasterStatusMutasi] (
    [idStatusMutasi] TINYINT      NOT NULL,
    [statusMutasi]   VARCHAR (50) NOT NULL,
    [caption]        VARCHAR (50) NULL,
    CONSTRAINT [PK_farmasiMasterStatusMutasi] PRIMARY KEY CLUSTERED ([idStatusMutasi] ASC)
);

