CREATE TABLE [dbo].[transaksiDiagnosaPasien] (
    [idDiagnosa]          INT            IDENTITY (1, 1) NOT NULL,
    [idPendaftaranPasien] BIGINT         NOT NULL,
    [idMasterDiagnosa]    INT            NULL,
    [idDokter]            INT            NULL,
    [idMasterICD]         INT            NULL,
    [anamnesa]            NVARCHAR (MAX) NULL,
    [tglDiagnosa]         DATE           NOT NULL,
    [tglEntry]            DATETIME       NOT NULL,
    [idRuangan]           INT            NULL,
    [idUserEntry]         INT            NOT NULL,
    [primer]              BIT            CONSTRAINT [DF_transaksiDiagnosaPasien_primer] DEFAULT ((0)) NULL,
    [baru]                BIT            NULL,
    [diagnosaAwal]        NVARCHAR (250) NULL,
    [flagDiagnosaAkhir]   BIT            CONSTRAINT [DF_transaksiDiagnosaPasien_flagDiagnosaAkhir] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_transaksiDiagnosaPasien] PRIMARY KEY CLUSTERED ([idDiagnosa] ASC),
    CONSTRAINT [FK_transaksiDiagnosaPasien_masterDiagnosa] FOREIGN KEY ([idMasterDiagnosa]) REFERENCES [dbo].[masterDiagnosa] ([idMasterDiagnosa]),
    CONSTRAINT [FK_transaksiDiagnosaPasien_masterICD] FOREIGN KEY ([idMasterICD]) REFERENCES [dbo].[masterICD] ([idMasterICD]),
    CONSTRAINT [FK_transaksiDiagnosaPasien_transaksiPendaftaranPasien] FOREIGN KEY ([idPendaftaranPasien]) REFERENCES [dbo].[transaksiPendaftaranPasien] ([idPendaftaranPasien])
);


GO
CREATE NONCLUSTERED INDEX [IX_idPendaftaranPasien]
    ON [dbo].[transaksiDiagnosaPasien]([idPendaftaranPasien] ASC);

