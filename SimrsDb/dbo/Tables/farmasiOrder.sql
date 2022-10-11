CREATE TABLE [dbo].[farmasiOrder] (
    [idOrder]               INT          IDENTITY (1, 1) NOT NULL,
    [idOrderSumberAnggaran] SMALLINT     NULL,
    [noOrder]               VARCHAR (50) NOT NULL,
    [tglOrder]              DATE         NOT NULL,
    [idDistriButor]         INT          NOT NULL,
    [idStatusOrder]         INT          CONSTRAINT [DF_farmasiOrder_idStatusOrder] DEFAULT ((1)) NOT NULL,
    [validasi]              BIT          CONSTRAINT [DF_farmasiOrder_validasi] DEFAULT ((0)) NOT NULL,
    [idUserEntry]           INT          NOT NULL,
    [idStatusBayar]         INT          CONSTRAINT [DF_farmasiOrder_idJenisBayar] DEFAULT ((2)) NOT NULL,
    [tglEntry]              DATETIME     CONSTRAINT [DF_farmasiOrder_tglEntry] DEFAULT (getdate()) NOT NULL,
    [tanggalModifikasi]     DATE         NULL,
    CONSTRAINT [PK_farmasiTransaksiOrder] PRIMARY KEY CLUSTERED ([idOrder] ASC),
    CONSTRAINT [FK_farmasiOrder_farmasiMasterDistrobutor] FOREIGN KEY ([idDistriButor]) REFERENCES [dbo].[farmasiMasterDistrobutor] ([idDistrobutor]),
    CONSTRAINT [FK_farmasiOrder_farmasiOrder] FOREIGN KEY ([idOrder]) REFERENCES [dbo].[farmasiOrder] ([idOrder]),
    CONSTRAINT [FK_farmasiOrder_farmasiOrderStatus] FOREIGN KEY ([idStatusOrder]) REFERENCES [dbo].[farmasiOrderStatus] ([idStatusOrder]),
    CONSTRAINT [FK_farmasiOrder_farmasiOrderSumberAnggaran] FOREIGN KEY ([idOrderSumberAnggaran]) REFERENCES [dbo].[farmasiOrderSumberAnggaran] ([idOrderSumberAnggaran]),
    CONSTRAINT [FK_farmasiOrder_masterStatusBayar] FOREIGN KEY ([idStatusBayar]) REFERENCES [dbo].[farmasiOrderStatusBayar] ([idStatusBayar]) ON UPDATE CASCADE
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_farmasiOrder]
    ON [dbo].[farmasiOrder]([noOrder] ASC);

