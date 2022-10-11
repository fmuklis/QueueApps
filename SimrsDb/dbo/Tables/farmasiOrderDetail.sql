CREATE TABLE [dbo].[farmasiOrderDetail] (
    [idOrderDetail] INT             IDENTITY (1, 1) NOT NULL,
    [idOrder]       INT             NOT NULL,
    [idPabrik]      INT             NULL,
    [idObatDosis]   INT             NOT NULL,
    [jumlah]        INT             NOT NULL,
    [harga]         MONEY           CONSTRAINT [DF_farmasiOrderDetail_harga] DEFAULT ((0)) NULL,
    [discount]      DECIMAL (18, 2) CONSTRAINT [DF_farmasiOrderDetail_discount] DEFAULT ((0)) NULL,
    [ppn]           DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_farmasiOrderDetail] PRIMARY KEY CLUSTERED ([idOrderDetail] ASC),
    CONSTRAINT [FK_farmasiOrderDetail_farmasiMasterObatDosis] FOREIGN KEY ([idObatDosis]) REFERENCES [dbo].[farmasiMasterObatDosis] ([idObatDosis]),
    CONSTRAINT [FK_farmasiOrderDetail_farmasiMasterPabrik] FOREIGN KEY ([idPabrik]) REFERENCES [dbo].[farmasiMasterPabrik] ([idPabrik]),
    CONSTRAINT [FK_farmasiOrderDetail_farmasiOrder] FOREIGN KEY ([idOrder]) REFERENCES [dbo].[farmasiOrder] ([idOrder]) ON DELETE CASCADE ON UPDATE CASCADE
);

