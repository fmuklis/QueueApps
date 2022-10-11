CREATE TABLE [dbo].[transaksiTindakanPasienDetail] (
    [idTindakanPasienDetail] INT    IDENTITY (1, 1) NOT NULL,
    [idTindakanPasien]       BIGINT NOT NULL,
    [idMasterKatagoriTarip]  INT    NOT NULL,
    [nilai]                  MONEY  NOT NULL,
    [jumlah]                 INT    NULL,
    CONSTRAINT [PK_transaksiTindakanPasienDetail] PRIMARY KEY CLUSTERED ([idTindakanPasienDetail] ASC),
    CONSTRAINT [FK_transaksiTindakanPasienDetail_masterTarifKatagori] FOREIGN KEY ([idMasterKatagoriTarip]) REFERENCES [dbo].[masterTarifKatagori] ([idMasterKatagoriTarip]),
    CONSTRAINT [FK_transaksiTindakanPasienDetail_transaksiTindakanPasien] FOREIGN KEY ([idTindakanPasien]) REFERENCES [dbo].[transaksiTindakanPasien] ([idTindakanPasien]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiTindakanPasienDetail_idTindakanPasien]
    ON [dbo].[transaksiTindakanPasienDetail]([idTindakanPasien] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiTindakanPasienDetail_idMasterKatagoriTarip]
    ON [dbo].[transaksiTindakanPasienDetail]([idMasterKatagoriTarip] ASC);

