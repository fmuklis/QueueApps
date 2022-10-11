CREATE TABLE [dbo].[masterTarifHeader] (
    [idMasterTarifHeader] INT            IDENTITY (1, 1) NOT NULL,
    [namaTarifHeader]     NVARCHAR (225) NOT NULL,
    [keterangan]          NVARCHAR (MAX) NULL,
    [BHP]                 BIT            CONSTRAINT [DF_masterTarifHeader_BHP] DEFAULT ((0)) NULL,
    [idMasterTarifGroup]  SMALLINT       NULL,
    CONSTRAINT [PK_masterTarifHeader] PRIMARY KEY CLUSTERED ([idMasterTarifHeader] ASC),
    CONSTRAINT [FK_masterTarifHeader_masterTarifGroup] FOREIGN KEY ([idMasterTarifGroup]) REFERENCES [dbo].[masterTarifGroup] ([idMasterTarifGroup])
);


GO
CREATE NONCLUSTERED INDEX [IX_masterTarifHeader]
    ON [dbo].[masterTarifHeader]([idMasterTarifHeader] ASC);

