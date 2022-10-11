CREATE TABLE [dbo].[transaksiTindakanPasienBHP] (
    [idTindakanBHP]    INT             IDENTITY (1, 1) NOT NULL,
    [idTindakanPasien] BIGINT          NOT NULL,
    [idObatDetail]     BIGINT          NOT NULL,
    [hargaJual]        MONEY           NOT NULL,
    [jumlah]           DECIMAL (18, 2) NOT NULL,
    [hargaPokok]       MONEY           NOT NULL,
    [flagPaket]        BIT             CONSTRAINT [DF_transaksiTindakanPasienBHP_flagPaket] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_transaksiTindakanPasienBPHP] PRIMARY KEY CLUSTERED ([idTindakanBHP] ASC),
    CONSTRAINT [FK_transaksiTindakanPasienBHP_farmasiMasterObatDetail] FOREIGN KEY ([idObatDetail]) REFERENCES [dbo].[farmasiMasterObatDetail] ([idObatDetail]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_transaksiTindakanPasienBHP_transaksiTindakanPasien] FOREIGN KEY ([idTindakanPasien]) REFERENCES [dbo].[transaksiTindakanPasien] ([idTindakanPasien]) ON DELETE CASCADE
);

