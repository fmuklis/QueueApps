CREATE TABLE [dbo].[masterTarip] (
    [idMasterTarif]          INT            IDENTITY (1, 1) NOT NULL,
    [idMasterTarifHeader]    INT            NULL,
    [idPeriodeTarip]         INT            NULL,
    [namaTarif]              NVARCHAR (225) NULL,
    [idMasterPelayanan]      INT            NOT NULL,
    [idKelas]                INT            NOT NULL,
    [idJenisTarif]           INT            NOT NULL,
    [idSatuanTarif]          INT            NOT NULL,
    [Keterangan]             NVARCHAR (MAX) NULL,
    [idMasterPaketPelayanan] INT            NULL,
    [flagTidakDijaminBPJS]   BIT            CONSTRAINT [DF_masterTarip_flagTidakDijaminBPJS] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_masterTaripRuangan] PRIMARY KEY CLUSTERED ([idMasterTarif] ASC),
    CONSTRAINT [FK_masterTarip_masterJenisTarip] FOREIGN KEY ([idJenisTarif]) REFERENCES [dbo].[masterJenisTarif] ([idJenisTarif]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_masterTarip_masterKelas] FOREIGN KEY ([idKelas]) REFERENCES [dbo].[masterKelas] ([idKelas]) ON UPDATE CASCADE,
    CONSTRAINT [FK_masterTarip_masterPaketPelayanan] FOREIGN KEY ([idMasterPaketPelayanan]) REFERENCES [dbo].[masterPaketPelayanan] ([idMasterPaketPelayanan]),
    CONSTRAINT [FK_masterTarip_masterPelayanan] FOREIGN KEY ([idMasterPelayanan]) REFERENCES [dbo].[masterPelayanan] ([idMasterPelayanan]),
    CONSTRAINT [FK_masterTarip_masterSatuanTarif] FOREIGN KEY ([idSatuanTarif]) REFERENCES [dbo].[masterSatuanTarif] ([idSatuanTarif]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_masterTarip_masterTarifHeader] FOREIGN KEY ([idMasterTarifHeader]) REFERENCES [dbo].[masterTarifHeader] ([idMasterTarifHeader]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_masterTarip_masterTaripPeriode] FOREIGN KEY ([idPeriodeTarip]) REFERENCES [dbo].[masterTaripPeriode] ([idPeriodeTarip])
);

