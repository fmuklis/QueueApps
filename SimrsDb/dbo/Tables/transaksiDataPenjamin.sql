CREATE TABLE [dbo].[transaksiDataPenjamin] (
    [idKartuPenjamin]                 INT           IDENTITY (1, 1) NOT NULL,
    [idPasien]                        BIGINT        NOT NULL,
    [idJenisPenjaminPembayaranPasien] INT           NOT NULL,
    [noPenjamin]                      NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_transaksiDataPenjaminn] PRIMARY KEY CLUSTERED ([idKartuPenjamin] ASC),
    CONSTRAINT [FK_transaksiDataPenjamin_masterJenisPenjaminPembayaranPasien] FOREIGN KEY ([idJenisPenjaminPembayaranPasien]) REFERENCES [dbo].[masterJenisPenjaminPembayaranPasien] ([idJenisPenjaminPembayaranPasien]),
    CONSTRAINT [FK_transaksiDataPenjamin_masterPasien] FOREIGN KEY ([idPasien]) REFERENCES [dbo].[masterPasien] ([idPasien])
);

