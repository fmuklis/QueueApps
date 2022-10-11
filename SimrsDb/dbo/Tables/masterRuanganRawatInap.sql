CREATE TABLE [dbo].[masterRuanganRawatInap] (
    [idRuanganRawatInap]        INT          IDENTITY (1, 1) NOT NULL,
    [idRuangan]                 INT          NOT NULL,
    [noRuanganRawatInap]        VARCHAR (50) NULL,
    [namaRuanganRawatInap]      VARCHAR (50) NOT NULL,
    [idKelas]                   INT          NOT NULL,
    [idJenisPelayananRawatInap] TINYINT      NULL,
    [idJenisKelamin]            TINYINT      NULL,
    CONSTRAINT [PK_masterRuanganRawatInap] PRIMARY KEY CLUSTERED ([idRuanganRawatInap] ASC),
    CONSTRAINT [FK_masterRuanganRawatInap_masterJenisKelamin] FOREIGN KEY ([idJenisKelamin]) REFERENCES [dbo].[masterJenisKelamin] ([idJenisKelamin]),
    CONSTRAINT [FK_masterRuanganRawatInap_masterJenisPelayananRawatInap] FOREIGN KEY ([idJenisPelayananRawatInap]) REFERENCES [dbo].[masterJenisPelayananRawatInap] ([idJenisPelayananRawatInap]),
    CONSTRAINT [FK_masterRuanganRawatInap_masterKelas] FOREIGN KEY ([idKelas]) REFERENCES [dbo].[masterKelas] ([idKelas]) ON UPDATE CASCADE,
    CONSTRAINT [FK_masterRuanganRawatInap_masterRuanganRawatInap] FOREIGN KEY ([idRuangan]) REFERENCES [dbo].[masterRuangan] ([idRuangan]) ON UPDATE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_masterRuanganRawatInap]
    ON [dbo].[masterRuanganRawatInap]([namaRuanganRawatInap] ASC);

