CREATE TABLE [dbo].[farmasiPembelianDetail] (
    [idPembelianDetail] BIGINT          IDENTITY (1, 1) NOT NULL,
    [idPembelianHeader] INT             NULL,
    [idOrderDetail]     INT             NULL,
    [kodeBatch]         VARCHAR (50)    NULL,
    [tglExpired]        DATE            NULL,
    [hargaBeli]         MONEY           NULL,
    [jumlahBeli]        DECIMAL (18, 2) NOT NULL,
    [discountUang]      MONEY           CONSTRAINT [DF_farmasiPembelianDetail_discountUang] DEFAULT ((0)) NULL,
    [discountPersen]    DECIMAL (18, 2) CONSTRAINT [DF_farmasiPembelianDetail_discountPersen] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_farmasiPembelianDetail] PRIMARY KEY CLUSTERED ([idPembelianDetail] ASC),
    CONSTRAINT [FK_farmasiPembelianDetail_farmasiOrderDetail] FOREIGN KEY ([idOrderDetail]) REFERENCES [dbo].[farmasiOrderDetail] ([idOrderDetail]),
    CONSTRAINT [FK_farmasiPembelianDetail_farmasiPembelian] FOREIGN KEY ([idPembelianHeader]) REFERENCES [dbo].[farmasiPembelian] ([idPembelianHeader])
);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiPembelianDetail_idOrderDetail]
    ON [dbo].[farmasiPembelianDetail]([idOrderDetail] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiPembelianDetail_idPembelianHeader]
    ON [dbo].[farmasiPembelianDetail]([idPembelianHeader] ASC);

