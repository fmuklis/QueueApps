CREATE TABLE [dbo].[bpjsSep] (
    [idSep]            BIGINT        IDENTITY (1, 1) NOT NULL,
    [idPasien]         BIGINT        NULL,
    [nomorSep]         VARCHAR (50)  NULL,
    [tanggalSep]       DATE          NOT NULL,
    [idJenisPerawatan] TINYINT       NOT NULL,
    [kodeKelasBPJS]    TINYINT       NOT NULL,
    [kodeFaskes]       VARCHAR (50)  NULL,
    [tanggalRujukan]   DATE          NULL,
    [nomorRujukan]     VARCHAR (50)  NULL,
    [kodePpkRujukan]   VARCHAR (50)  NULL,
    [catatan]          VARCHAR (500) NULL,
    [idMasterICD]      INT           NOT NULL,
    [kodePoli]         VARCHAR (50)  NOT NULL,
    [eksekutif]        BIT           NOT NULL,
    [cob]              BIT           NOT NULL,
    [katarak]          BIT           NOT NULL,
    [lakaLantas]       BIT           NOT NULL,
    [tanggalKejadian]  DATE          NULL,
    [keterangan]       VARCHAR (500) NULL,
    [suplesi]          BIT           NOT NULL,
    [sepSuplesi]       VARCHAR (50)  NULL,
    [kodeKecamatan]    VARCHAR (50)  NULL,
    [nomorSurat]       VARCHAR (50)  NULL,
    [kodeDpjp]         VARCHAR (50)  NULL,
    [dpjpLayan]        VARCHAR (50)  NULL,
    [idJenisLaka]      TINYINT       NULL,
    CONSTRAINT [PK_bpjsSep] PRIMARY KEY CLUSTERED ([idSep] ASC),
    CONSTRAINT [FK_bpjsSep_bpjsMasterDpjp] FOREIGN KEY ([kodeDpjp]) REFERENCES [dbo].[bpjsMasterDpjp] ([kodeDpjp]),
    CONSTRAINT [FK_bpjsSep_bpjsMasterFaskes] FOREIGN KEY ([kodeFaskes]) REFERENCES [dbo].[bpjsMasterFaskes] ([kodeFaskes]),
    CONSTRAINT [FK_bpjsSep_bpjsMasterKecamatan] FOREIGN KEY ([kodeKecamatan]) REFERENCES [dbo].[bpjsMasterKecamatan] ([kodeKecamatan]),
    CONSTRAINT [FK_bpjsSep_bpjsMasterPoli] FOREIGN KEY ([kodePoli]) REFERENCES [dbo].[bpjsMasterPoli] ([kodePoli]),
    CONSTRAINT [FK_bpjsSep_bpjsMasterPpk] FOREIGN KEY ([kodePpkRujukan]) REFERENCES [dbo].[bpjsMasterPpk] ([kodePpkRujukan]),
    CONSTRAINT [FK_bpjsSep_constJenisLaka] FOREIGN KEY ([idJenisLaka]) REFERENCES [dbo].[constJenisLaka] ([idJenisLaka]),
    CONSTRAINT [FK_bpjsSep_masterICD] FOREIGN KEY ([idMasterICD]) REFERENCES [dbo].[masterICD] ([idMasterICD]),
    CONSTRAINT [FK_bpjsSep_masterJenisPerawatan] FOREIGN KEY ([idJenisPerawatan]) REFERENCES [dbo].[masterJenisPerawatan] ([idJenisPerawatan]),
    CONSTRAINT [FK_bpjsSep_masterPasien] FOREIGN KEY ([idPasien]) REFERENCES [dbo].[masterPasien] ([idPasien])
);


GO
CREATE NONCLUSTERED INDEX [IX_bpjsSep_idPasien]
    ON [dbo].[bpjsSep]([idPasien] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_bpjsSep_nomorSep]
    ON [dbo].[bpjsSep]([nomorSep] ASC);

