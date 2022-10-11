CREATE TABLE [dbo].[masterTarifKamar] (
    [idMasterTarifKamar] INT   IDENTITY (1, 1) NOT NULL,
    [idKelas]            INT   NOT NULL,
    [tarif]              MONEY NOT NULL,
    [hargaPokok]         MONEY NOT NULL,
    CONSTRAINT [PK_masterTarifKamar] PRIMARY KEY CLUSTERED ([idMasterTarifKamar] ASC),
    CONSTRAINT [FK_masterTarifKamar_masterKelas] FOREIGN KEY ([idKelas]) REFERENCES [dbo].[masterKelas] ([idKelas]) ON UPDATE CASCADE
);

