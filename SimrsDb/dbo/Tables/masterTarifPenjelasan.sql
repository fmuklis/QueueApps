CREATE TABLE [dbo].[masterTarifPenjelasan] (
    [idMasterTarifPenjelasan] INT            IDENTITY (1, 1) NOT NULL,
    [idMasterTarif]           INT            NOT NULL,
    [penjelasanTarif]         NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_masterTarifPenjelasan] PRIMARY KEY CLUSTERED ([idMasterTarifPenjelasan] ASC),
    CONSTRAINT [FK_masterTarifPenjelasan_masterTarifPenjelasan] FOREIGN KEY ([idMasterTarifPenjelasan]) REFERENCES [dbo].[masterTarifPenjelasan] ([idMasterTarifPenjelasan])
);

