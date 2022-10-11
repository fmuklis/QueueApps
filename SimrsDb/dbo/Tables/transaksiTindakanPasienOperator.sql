CREATE TABLE [dbo].[transaksiTindakanPasienOperator] (
    [idTindakanPasienOperator] INT    IDENTITY (1, 1) NOT NULL,
    [idTindakanPasien]         BIGINT NOT NULL,
    [idMasterKatagoriTarip]    INT    NULL,
    [idOperator]               INT    NOT NULL,
    [idTindakanPasienDetail]   INT    NULL,
    CONSTRAINT [PK_transaksiTindakanPasienOperator] PRIMARY KEY CLUSTERED ([idTindakanPasienOperator] ASC),
    CONSTRAINT [FK_transaksiTindakanPasienOperator_masterOperator] FOREIGN KEY ([idOperator]) REFERENCES [dbo].[masterOperator] ([idOperator]),
    CONSTRAINT [FK_transaksiTindakanPasienOperator_transaksiTindakanPasien] FOREIGN KEY ([idTindakanPasien]) REFERENCES [dbo].[transaksiTindakanPasien] ([idTindakanPasien]),
    CONSTRAINT [FK_transaksiTindakanPasienOperator_transaksiTindakanPasienDetail] FOREIGN KEY ([idTindakanPasienDetail]) REFERENCES [dbo].[transaksiTindakanPasienDetail] ([idTindakanPasienDetail]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiTindakanPasienOperator_idTindakanPasienDetail]
    ON [dbo].[transaksiTindakanPasienOperator]([idTindakanPasienDetail] ASC);

