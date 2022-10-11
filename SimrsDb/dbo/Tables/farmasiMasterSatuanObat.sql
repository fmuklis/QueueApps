CREATE TABLE [dbo].[farmasiMasterSatuanObat] (
    [idSatuanObat]   INT           IDENTITY (1, 1) NOT NULL,
    [namaSatuanObat] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_farmasiMasterSatuanObat] PRIMARY KEY CLUSTERED ([idSatuanObat] ASC)
);

