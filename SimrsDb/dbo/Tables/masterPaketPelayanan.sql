CREATE TABLE [dbo].[masterPaketPelayanan] (
    [idMasterPaketPelayanan] INT IDENTITY (1, 1) NOT NULL,
    [idMasterPelayanan]      INT NOT NULL,
    [idMasterTarifPaket]     INT NOT NULL,
    CONSTRAINT [PK_masterPaketPelayanan] PRIMARY KEY CLUSTERED ([idMasterPaketPelayanan] ASC),
    CONSTRAINT [FK_masterPaketPelayanan_masterPelayanan] FOREIGN KEY ([idMasterPelayanan]) REFERENCES [dbo].[masterPelayanan] ([idMasterPelayanan]),
    CONSTRAINT [FK_masterPaketPelayanan_masterTarifPaket] FOREIGN KEY ([idMasterTarifPaket]) REFERENCES [dbo].[masterTarifPaket] ([idMasterTarifPaket])
);

