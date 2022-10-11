CREATE TABLE [dbo].[farmasiMasterObatDosis] (
    [idObatDosis]      INT             IDENTITY (1, 1) NOT NULL,
    [idObat]           INT             NOT NULL,
    [idSatuanDosis]    INT             NOT NULL,
    [dosis]            DECIMAL (18, 2) NOT NULL,
    [hargaJual]        MONEY           CONSTRAINT [DF_farmasiMasterObatDosis_hargaJual] DEFAULT ((0)) NULL,
    [maxPeresepanBPJS] INT             NULL,
    CONSTRAINT [PK_farmasiMasterObatDosis] PRIMARY KEY CLUSTERED ([idObatDosis] ASC),
    CONSTRAINT [FK_farmasiMasterObatDosis_farmasiMasterObatDetail] FOREIGN KEY ([idObat]) REFERENCES [dbo].[farmasiMasterObat] ([idObat]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_farmasiMasterObatDosis_farmasiMasterObatSatuanDosis] FOREIGN KEY ([idSatuanDosis]) REFERENCES [dbo].[farmasiMasterObatSatuanDosis] ([idSatuanDosis])
);

