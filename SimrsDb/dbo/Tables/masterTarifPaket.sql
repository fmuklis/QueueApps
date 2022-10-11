CREATE TABLE [dbo].[masterTarifPaket] (
    [idMasterTarifPaket] INT           IDENTITY (1, 1) NOT NULL,
    [namaTarifPaket]     NVARCHAR (50) NOT NULL,
    [tarif]              MONEY         NOT NULL,
    CONSTRAINT [PK_masterTarifPaket] PRIMARY KEY CLUSTERED ([idMasterTarifPaket] ASC)
);

