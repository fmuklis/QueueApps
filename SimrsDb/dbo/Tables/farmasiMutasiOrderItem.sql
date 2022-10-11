CREATE TABLE [dbo].[farmasiMutasiOrderItem] (
    [idItemOrderMutasi] BIGINT          IDENTITY (1, 1) NOT NULL,
    [idMutasi]          BIGINT          NOT NULL,
    [idObatDosis]       INT             NOT NULL,
    [sisaStok]          DECIMAL (18, 2) CONSTRAINT [DF_farmasiMutasiItemOrder_sisaStok] DEFAULT ((0)) NOT NULL,
    [jumlahOrder]       DECIMAL (18, 2) CONSTRAINT [DF_farmasiMutasiOrderItem_jumlahOrder] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_farmasiMutasiItemOrder] PRIMARY KEY CLUSTERED ([idItemOrderMutasi] ASC),
    CONSTRAINT [FK_farmasiMutasiOrderItem_farmasiMasterObatDosis] FOREIGN KEY ([idObatDosis]) REFERENCES [dbo].[farmasiMasterObatDosis] ([idObatDosis]),
    CONSTRAINT [FK_farmasiMutasiOrderItem_farmasiMutasi] FOREIGN KEY ([idMutasi]) REFERENCES [dbo].[farmasiMutasi] ([idMutasi]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiMutasiOrderItem_idMutasi]
    ON [dbo].[farmasiMutasiOrderItem]([idMutasi] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_farmasiMutasiOrderItem_idMts_idOd]
    ON [dbo].[farmasiMutasiOrderItem]([idMutasi] ASC, [idObatDosis] ASC);

