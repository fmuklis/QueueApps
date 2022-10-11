CREATE TABLE [dbo].[transaksiKonsul] (
    [idTransaksiKonsul]   BIGINT        IDENTITY (1, 1) NOT NULL,
    [idPendaftaranPasien] BIGINT        NOT NULL,
    [idRuanganAsal]       INT           NULL,
    [idRuanganTujuan]     INT           NOT NULL,
    [tglOrderKonsul]      DATETIME      NOT NULL,
    [idStatusKonsul]      TINYINT       CONSTRAINT [DF_transaksiKonsul_idStatusKonsul] DEFAULT ((1)) NOT NULL,
    [alasan]              VARCHAR (MAX) NULL,
    [itemKonsul]          VARCHAR (MAX) NULL,
    [jawaban]             VARCHAR (MAX) NULL,
    [anjuran]             VARCHAR (MAX) NULL,
    [idUserEntry]         INT           NOT NULL,
    [tanggalEntry]        DATETIME      CONSTRAINT [DF_transaksiKonsul_tanggalEntry] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_transaksiKonsul] PRIMARY KEY CLUSTERED ([idTransaksiKonsul] ASC),
    CONSTRAINT [FK_transaksiKonsul_masterRuangan] FOREIGN KEY ([idRuanganTujuan]) REFERENCES [dbo].[masterRuangan] ([idRuangan]),
    CONSTRAINT [FK_transaksiKonsul_masterStatusKonsul] FOREIGN KEY ([idStatusKonsul]) REFERENCES [dbo].[masterStatusKonsul] ([idStatusKonsul]),
    CONSTRAINT [FK_transaksiKonsul_masterUser] FOREIGN KEY ([idUserEntry]) REFERENCES [dbo].[masterUser] ([idUser]),
    CONSTRAINT [FK_transaksiKonsul_transaksiKonsul] FOREIGN KEY ([idTransaksiKonsul]) REFERENCES [dbo].[transaksiKonsul] ([idTransaksiKonsul]),
    CONSTRAINT [FK_transaksiKonsul_transaksiPendaftaranPasien] FOREIGN KEY ([idPendaftaranPasien]) REFERENCES [dbo].[transaksiPendaftaranPasien] ([idPendaftaranPasien]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiKonsul_idStatusKonsul]
    ON [dbo].[transaksiKonsul]([idStatusKonsul] ASC, [idRuanganTujuan] ASC, [idRuanganAsal] ASC);

