CREATE TABLE [dbo].[farmasiResepSaatKonsumsi] (
    [idSaatKonsumsi] INT        NOT NULL,
    [saatKonsumsi]   NCHAR (50) NOT NULL,
    CONSTRAINT [PK_farmasiResepSaatKonsumsi] PRIMARY KEY CLUSTERED ([idSaatKonsumsi] ASC)
);

