CREATE TABLE [dbo].[farmasiMasterStatusRetur] (
    [idStatusRetur] TINYINT      NOT NULL,
    [statusRetur]   VARCHAR (50) NULL,
    [caption]       VARCHAR (50) NULL,
    CONSTRAINT [PK_farmasiMasterStatusRetur] PRIMARY KEY CLUSTERED ([idStatusRetur] ASC)
);

