CREATE TABLE [dbo].[masterSatuanTarif] (
    [idSatuanTarif]   INT           IDENTITY (1, 1) NOT NULL,
    [namaSatuanTarif] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterSatuanTarif] PRIMARY KEY CLUSTERED ([idSatuanTarif] ASC)
);

