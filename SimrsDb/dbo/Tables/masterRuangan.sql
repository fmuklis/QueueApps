CREATE TABLE [dbo].[masterRuangan] (
    [idRuangan]         INT          IDENTITY (1, 1) NOT NULL,
    [alias]             VARCHAR (50) NULL,
    [namaRuangan]       VARCHAR (50) NOT NULL,
    [idMasterPelayanan] INT          NULL,
    [idJenisRuangan]    INT          NULL,
    [idJenisStok]       INT          NULL,
    [idJenisOperator]   INT          NULL,
    [idPetugasEntryBhp] TINYINT      CONSTRAINT [DF_masterRuangan_idPetugasEntryBhp] DEFAULT ((1)) NULL,
    [aktif]             BIT          CONSTRAINT [DF_masterRuangan_aktif] DEFAULT ((1)) NOT NULL,
    [idTPO]             INT          NULL,
    CONSTRAINT [PK_masterRuangan] PRIMARY KEY CLUSTERED ([idRuangan] ASC),
    CONSTRAINT [FK_masterRuangan_masterRuanganJenis] FOREIGN KEY ([idJenisRuangan]) REFERENCES [dbo].[masterRuanganJenis] ([idJenisRuangan])
);


GO
CREATE NONCLUSTERED INDEX [IX_masterRuangan]
    ON [dbo].[masterRuangan]([namaRuangan] ASC);

