CREATE TABLE [dbo].[transaksiPenjaminPembayaranPasienOld] (
    [idPenjaminPembayaran]            INT             IDENTITY (1, 1) NOT NULL,
    [namaPenjaminPembayaranPasien]    NVARCHAR (50)   NULL,
    [idPendaftaranPasien]             BIGINT          NOT NULL,
    [idJenisPenjaminPembayaranPasien] INT             NOT NULL,
    [noKartuPenjaminPembayaranPasien] NVARCHAR (50)   NULL,
    [masaBerlakuKartuPenjaminPasien]  DATE            NULL,
    [persentaseJaminan]               DECIMAL (18, 2) NULL,
    [idKelas]                         INT             NULL,
    CONSTRAINT [PK_transaksiPenjaminPembayaranPasien] PRIMARY KEY CLUSTERED ([idPenjaminPembayaran] ASC),
    CONSTRAINT [FK_transaksiPenjaminPembayaranPasien_masterJenisPenjaminPembayaranPasien] FOREIGN KEY ([idJenisPenjaminPembayaranPasien]) REFERENCES [dbo].[masterJenisPenjaminPembayaranPasien] ([idJenisPenjaminPembayaranPasien]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_transaksiPenjaminPembayaranPasien_transaksiPendaftaranPasien] FOREIGN KEY ([idPendaftaranPasien]) REFERENCES [dbo].[transaksiPendaftaranPasien] ([idPendaftaranPasien]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [IX_transaksiPenjaminPembayaranPasien] UNIQUE NONCLUSTERED ([idPendaftaranPasien] ASC, [idJenisPenjaminPembayaranPasien] ASC)
);

