CREATE TABLE [dbo].[transaksiOrderRawatInapPindahKamar] (
    [idOrderPindahKamar]        INT            IDENTITY (1, 1) NOT NULL,
    [idTransaksiOrderRawatInap] BIGINT         NOT NULL,
    [idUserEntry]               INT            NOT NULL,
    [tglEntry]                  DATETIME       NOT NULL,
    [tglOrderPindahKamar]       DATE           NOT NULL,
    [keterangan]                NVARCHAR (MAX) NOT NULL,
    [flagStatus]                BIT            CONSTRAINT [DF_transaksiOrderRawatInapPindahKamar_flagStatus] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_transaksiOrderRawatInapPindahKamar] PRIMARY KEY CLUSTERED ([idOrderPindahKamar] ASC),
    CONSTRAINT [FK_transaksiOrderRawatInapPindahKamar_transaksiOrderRawatInap] FOREIGN KEY ([idTransaksiOrderRawatInap]) REFERENCES [dbo].[transaksiOrderRawatInap] ([idTransaksiOrderRawatInap])
);

