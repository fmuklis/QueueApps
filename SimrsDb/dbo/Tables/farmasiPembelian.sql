CREATE TABLE [dbo].[farmasiPembelian] (
    [idPembelianHeader]       INT             IDENTITY (1, 1) NOT NULL,
    [noFaktur]                VARCHAR (50)    NULL,
    [tglPembelian]            DATE            NULL,
    [tglEntry]                DATETIME        NULL,
    [userIdEntry]             INT             NULL,
    [keterangan]              NVARCHAR (MAX)  NULL,
    [idStatusPembelian]       TINYINT         CONSTRAINT [DF_farmasiPembelian_idStatusPembelian] DEFAULT ((1)) NULL,
    [tglJatuhTempoPembayaran] DATE            NULL,
    [ppn]                     DECIMAL (18, 2) NULL,
    [idOrder]                 INT             NULL,
    [idStatusBayar]           INT             NULL,
    [idMetodeBayar]           INT             NULL,
    [penerimaPembayaran]      NVARCHAR (50)   NULL,
    CONSTRAINT [PK_farmasiPembelian] PRIMARY KEY CLUSTERED ([idPembelianHeader] ASC),
    CONSTRAINT [FK_farmasiPembelian_farmasiMasterStatusPembelian] FOREIGN KEY ([idStatusPembelian]) REFERENCES [dbo].[farmasiMasterStatusPembelian] ([idStatusPembelian])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_farmasiPembelian_noFaktur]
    ON [dbo].[farmasiPembelian]([noFaktur] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiPembelian_tglPembelian]
    ON [dbo].[farmasiPembelian]([tglPembelian] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiPembelian_idOrder]
    ON [dbo].[farmasiPembelian]([idOrder] ASC);

