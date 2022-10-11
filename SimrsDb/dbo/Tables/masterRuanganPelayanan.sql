CREATE TABLE [dbo].[masterRuanganPelayanan] (
    [idMasterRuanganPelayanan] INT IDENTITY (1, 1) NOT NULL,
    [idRuangan]                INT NOT NULL,
    [idMasterPelayanan]        INT NOT NULL,
    CONSTRAINT [PK_masterRuanganPelayanan] PRIMARY KEY CLUSTERED ([idMasterRuanganPelayanan] ASC),
    CONSTRAINT [FK_masterRuanganPelayanan_masterPelayanan] FOREIGN KEY ([idMasterPelayanan]) REFERENCES [dbo].[masterPelayanan] ([idMasterPelayanan]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_masterRuanganPelayanan_masterRuangan] FOREIGN KEY ([idRuangan]) REFERENCES [dbo].[masterRuangan] ([idRuangan]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_masterRuanganPelayanan]
    ON [dbo].[masterRuanganPelayanan]([idRuangan] ASC, [idMasterPelayanan] ASC);

