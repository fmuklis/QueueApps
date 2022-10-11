CREATE TABLE [dbo].[farmasiMasterStatusPenjualan] (
    [idStatusPenjualan] TINYINT      IDENTITY (1, 1) NOT NULL,
    [statusPenjualan]   VARCHAR (50) NOT NULL,
    [caption]           VARCHAR (50) NULL,
    CONSTRAINT [PK_farmasiMasterStatusPenjualan] PRIMARY KEY CLUSTERED ([idStatusPenjualan] ASC)
);

