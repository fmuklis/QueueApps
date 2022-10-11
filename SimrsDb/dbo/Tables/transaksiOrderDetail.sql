CREATE TABLE [dbo].[transaksiOrderDetail] (
    [idOrderDetail] BIGINT IDENTITY (1, 1) NOT NULL,
    [idOrder]       BIGINT NOT NULL,
    [idMasterTarif] INT    NOT NULL,
    [idUserEntry]   INT    NULL,
    CONSTRAINT [PK_transaksiOrderDetail] PRIMARY KEY CLUSTERED ([idOrderDetail] ASC),
    CONSTRAINT [FK_transaksiOrderDetail_transaksiOrder] FOREIGN KEY ([idOrder]) REFERENCES [dbo].[transaksiOrder] ([idOrder]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiOrderDetail_idOrder]
    ON [dbo].[transaksiOrderDetail]([idOrder] ASC);

