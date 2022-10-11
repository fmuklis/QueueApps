CREATE TABLE [dbo].[transaksiPendaftaranPasienAttachment] (
    [idTransaksiPendaftaranPasienAttachment] INT           IDENTITY (1, 1) NOT NULL,
    [attachment]                             VARCHAR (100) NOT NULL,
    [idPendaftaranPasien]                    BIGINT        NOT NULL,
    [idStatusPendaftaranAttachment]          TINYINT       NOT NULL,
    CONSTRAINT [PK_transaksiPendaftaranPasienAttachment] PRIMARY KEY CLUSTERED ([idTransaksiPendaftaranPasienAttachment] ASC),
    CONSTRAINT [FK_transaksiPendaftaranPasienAttachment_masterStatusPendaftaranAttachment] FOREIGN KEY ([idStatusPendaftaranAttachment]) REFERENCES [dbo].[masterStatusPendaftaranAttachment] ([idStatusPendaftaranAttachment]),
    CONSTRAINT [FK_transaksiPendaftaranPasienAttachment_transaksiPendaftaranPasienAttachment] FOREIGN KEY ([idTransaksiPendaftaranPasienAttachment]) REFERENCES [dbo].[transaksiPendaftaranPasienAttachment] ([idTransaksiPendaftaranPasienAttachment])
);

