CREATE TABLE [dbo].[farmasiMasterObatSatuanDosis] (
    [idSatuanDosis]   INT           IDENTITY (1, 1) NOT NULL,
    [namaSatuanDosis] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_farmasiMasterObatSatuanDosis] PRIMARY KEY CLUSTERED ([idSatuanDosis] ASC)
);

