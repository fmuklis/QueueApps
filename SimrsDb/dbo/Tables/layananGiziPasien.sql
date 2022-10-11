CREATE TABLE [dbo].[layananGiziPasien] (
    [idLayananGiziPasien] INT           IDENTITY (1, 1) NOT NULL,
    [idJadwalKonsumsi]    TINYINT       NOT NULL,
    [idPendafaranPasien]  BIGINT        NOT NULL,
    [tanggalKonsumsi]     DATE          NOT NULL,
    [keteranganDiet]      VARCHAR (250) NULL,
    [jenisDiet]           VARCHAR (250) NULL,
    [idTempatTidur]       INT           NULL,
    [tanggalEntry]        SMALLDATETIME CONSTRAINT [DF_layananGiziPasien_tanggalEntry] DEFAULT (getdate()) NOT NULL,
    [idUserEntry]         INT           NULL,
    CONSTRAINT [PK_layananGiziPasien] PRIMARY KEY CLUSTERED ([idLayananGiziPasien] ASC),
    CONSTRAINT [FK_layananGiziPasien_constKonsumsiJadwal] FOREIGN KEY ([idJadwalKonsumsi]) REFERENCES [dbo].[constKonsumsiJadwal] ([idJadwalKonsumsi]),
    CONSTRAINT [FK_layananGiziPasien_transaksiPendaftaranPasien] FOREIGN KEY ([idPendafaranPasien]) REFERENCES [dbo].[transaksiPendaftaranPasien] ([idPendaftaranPasien])
);


GO
CREATE NONCLUSTERED INDEX [IX_konsumsiPasien_tanggalKonsumsi]
    ON [dbo].[layananGiziPasien]([tanggalKonsumsi] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_konsumsiPasien_idPendafaranPasien]
    ON [dbo].[layananGiziPasien]([idPendafaranPasien] ASC);

