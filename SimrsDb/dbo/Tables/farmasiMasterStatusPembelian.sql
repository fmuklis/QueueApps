CREATE TABLE [dbo].[farmasiMasterStatusPembelian] (
    [idStatusPembelian] TINYINT      IDENTITY (1, 1) NOT NULL,
    [statusPembelian]   VARCHAR (50) NOT NULL,
    [caption]           VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_farmasiMasterStatusPembelian] PRIMARY KEY CLUSTERED ([idStatusPembelian] ASC),
    CONSTRAINT [FK_farmasiMasterStatusPembelian_farmasiMasterStatusPembelian] FOREIGN KEY ([idStatusPembelian]) REFERENCES [dbo].[farmasiMasterStatusPembelian] ([idStatusPembelian])
);

