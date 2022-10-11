CREATE TABLE [dbo].[transaksiOrderRawatInap] (
    [idTransaksiOrderRawatInap] BIGINT        IDENTITY (1, 1) NOT NULL,
    [tglOrder]                  DATETIME      CONSTRAINT [DF_transaksiOrderRawatInap_tglOrder] DEFAULT (getdate()) NOT NULL,
    [idJenisRequest]            INT           CONSTRAINT [DF_transaksiOrderRawatInap_idJenisRequest] DEFAULT ((1)) NULL,
    [idPendaftaranPasien]       BIGINT        NOT NULL,
    [idDokter]                  INT           NULL,
    [idStatusOrderRawatInap]    INT           CONSTRAINT [DF_transaksiOrderRawatInap_idStatusOrderRawatInap] DEFAULT ((1)) NULL,
    [idRuanganAsal]             INT           NOT NULL,
    [idDPJP]                    INT           NULL,
    [catatan]                   VARCHAR (MAX) NULL,
    [idUserEntry]               INT           NULL,
    [tanggalEntry]              DATETIME      CONSTRAINT [DF_transaksiOrderRawatInap_tanggalEntry] DEFAULT (getdate()) NULL,
    [tglRencanaRanap]           DATE          CONSTRAINT [DF_transaksiOrderRawatInap_tglRencanaRanap] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_transaksiOrderRawatInap] PRIMARY KEY CLUSTERED ([idTransaksiOrderRawatInap] ASC),
    CONSTRAINT [FK_transaksiOrderRawatInap_masterOperator] FOREIGN KEY ([idDPJP]) REFERENCES [dbo].[masterOperator] ([idOperator]),
    CONSTRAINT [FK_transaksiOrderRawatInap_masterRuangan] FOREIGN KEY ([idRuanganAsal]) REFERENCES [dbo].[masterRuangan] ([idRuangan]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_transaksiOrderRawatInap_transaksiPendaftaranPasien] FOREIGN KEY ([idPendaftaranPasien]) REFERENCES [dbo].[transaksiPendaftaranPasien] ([idPendaftaranPasien]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_transaksiOrderRawatInap_idPendaftaranPasien]
    ON [dbo].[transaksiOrderRawatInap]([idPendaftaranPasien] ASC);

