CREATE TABLE [dbo].[bpjsSepPengajuan] (
    [idPengajuan]    BIGINT        IDENTITY (1, 1) NOT NULL,
    [noKartu]        VARCHAR (50)  NOT NULL,
    [tanggalSep]     DATE          NOT NULL,
    [jenisPelayanan] TINYINT       NOT NULL,
    [keterangan]     VARCHAR (500) NOT NULL,
    [approve]        BIT           CONSTRAINT [DF_bpjsSepPengajuan_approve] DEFAULT ((0)) NOT NULL,
    [tanggalEntry]   DATETIME      CONSTRAINT [DF_bpjsSepPengajuan_tanggalEntry] DEFAULT (getdate()) NOT NULL,
    [jenisPengajuan] TINYINT       NULL,
    CONSTRAINT [PK_bpjsSepPengajuan] PRIMARY KEY CLUSTERED ([idPengajuan] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_bpjsSepPengajuan_noKartu]
    ON [dbo].[bpjsSepPengajuan]([noKartu] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_bpjsSepPengajuan_approve]
    ON [dbo].[bpjsSepPengajuan]([approve] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_bpjsSepPengajuan_tanggalEntry]
    ON [dbo].[bpjsSepPengajuan]([tanggalEntry] ASC);

