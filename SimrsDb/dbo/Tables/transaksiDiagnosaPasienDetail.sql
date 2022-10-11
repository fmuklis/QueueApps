CREATE TABLE [dbo].[transaksiDiagnosaPasienDetail] (
    [idDiagnosaDetail] INT      IDENTITY (1, 1) NOT NULL,
    [idDiagnosa]       INT      NOT NULL,
    [sekunder]         BIT      NOT NULL,
    [idPenyakit]       INT      NOT NULL,
    [idUserEntry]      INT      NOT NULL,
    [tglEntry]         DATETIME NOT NULL,
    CONSTRAINT [PK_transaksiDiagnosaPasienDetail] PRIMARY KEY CLUSTERED ([idDiagnosaDetail] ASC),
    CONSTRAINT [FK_transaksiDiagnosaPasienDetail_masterPenyakit] FOREIGN KEY ([idPenyakit]) REFERENCES [dbo].[masterPenyakit] ([idPenyakit]),
    CONSTRAINT [FK_transaksiDiagnosaPasienDetail_masterUser] FOREIGN KEY ([idUserEntry]) REFERENCES [dbo].[masterUser] ([idUser]),
    CONSTRAINT [FK_transaksiDiagnosaPasienDetail_transaksiDiagnosaPasien] FOREIGN KEY ([idDiagnosa]) REFERENCES [dbo].[transaksiDiagnosaPasien] ([idDiagnosa])
);

