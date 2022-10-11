CREATE TABLE [dbo].[transaksiBillingPembayaran] (
    [idPembayaran]  BIGINT   IDENTITY (1, 1) NOT NULL,
    [idBilling]     BIGINT   NOT NULL,
    [idMetodeBayar] TINYINT  NOT NULL,
    [jumlahBayar]   MONEY    NOT NULL,
    [tanggalEntry]  DATETIME CONSTRAINT [DF_transaksiBillingPembayaran_tanggalEntry] DEFAULT (getdate()) NOT NULL,
    [idUserEntry]   INT      NOT NULL,
    CONSTRAINT [PK_transaksiBillingPembayaran] PRIMARY KEY CLUSTERED ([idPembayaran] ASC),
    CONSTRAINT [FK_transaksiBillingPembayaran_masterMetodeBayar] FOREIGN KEY ([idMetodeBayar]) REFERENCES [dbo].[masterMetodeBayar] ([idMetodeBayar]) ON UPDATE CASCADE,
    CONSTRAINT [FK_transaksiBillingPembayaran_masterUser] FOREIGN KEY ([idUserEntry]) REFERENCES [dbo].[masterUser] ([idUser]),
    CONSTRAINT [FK_transaksiBillingPembayaran_transaksiBillingHeader] FOREIGN KEY ([idBilling]) REFERENCES [dbo].[transaksiBillingHeader] ([idBilling]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiBillingPembayaran_idBilling]
    ON [dbo].[transaksiBillingPembayaran]([idBilling] ASC, [idMetodeBayar] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_transaksiBillingPembayaran_uniqueKey]
    ON [dbo].[transaksiBillingPembayaran]([idBilling] ASC, [idMetodeBayar] ASC);

