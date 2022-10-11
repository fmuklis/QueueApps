CREATE TABLE [dbo].[farmasiStokOpnameDetail] (
    [idStokOpnameDetail] BIGINT          IDENTITY (1, 1) NOT NULL,
    [idStokOpname]       BIGINT          NOT NULL,
    [idJenisStokOpname]  TINYINT         CONSTRAINT [DF_farmasiStokOpnameDetail_idJenisStokOpname] DEFAULT ((1)) NOT NULL,
    [idObatDetail]       BIGINT          NULL,
    [idObatDosis]        INT             NULL,
    [kodeBatch]          VARCHAR (50)    NULL,
    [tglExpired]         DATE            NULL,
    [hargaPokok]         MONEY           NULL,
    [jumlahAwal]         DECIMAL (18, 2) CONSTRAINT [DF_farmasiStokOpnameDetail_jumlahAwal] DEFAULT ((0)) NOT NULL,
    [jumlahStokOpname]   DECIMAL (18, 2) NOT NULL,
    [keterangan]         VARCHAR (50)    NULL,
    [idUserEntry]        INT             NULL,
    CONSTRAINT [PK_farmasiStokOpnameDetail] PRIMARY KEY CLUSTERED ([idStokOpnameDetail] ASC),
    CONSTRAINT [FK_farmasiStokOpnameDetail_farmasiMasterJenisStokOpname] FOREIGN KEY ([idJenisStokOpname]) REFERENCES [dbo].[farmasiMasterJenisStokOpname] ([idJenisStokOpname]),
    CONSTRAINT [FK_farmasiStokOpnameDetail_farmasiMasterObatDetail] FOREIGN KEY ([idObatDetail]) REFERENCES [dbo].[farmasiMasterObatDetail] ([idObatDetail]),
    CONSTRAINT [FK_farmasiStokOpnameDetail_farmasiMasterObatDosis] FOREIGN KEY ([idObatDosis]) REFERENCES [dbo].[farmasiMasterObatDosis] ([idObatDosis]),
    CONSTRAINT [FK_farmasiStokOpnameDetail_farmasiStokOpname] FOREIGN KEY ([idStokOpname]) REFERENCES [dbo].[farmasiStokOpname] ([idStokOpname]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiStokOpnameDetail_idStokOpname]
    ON [dbo].[farmasiStokOpnameDetail]([idStokOpname] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiStokOpnameDetail_idJenisStokOpname]
    ON [dbo].[farmasiStokOpnameDetail]([idJenisStokOpname] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiStokOpnameDetail_idObatDetail]
    ON [dbo].[farmasiStokOpnameDetail]([idObatDetail] ASC);

