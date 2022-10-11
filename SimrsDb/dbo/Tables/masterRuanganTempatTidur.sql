CREATE TABLE [dbo].[masterRuanganTempatTidur] (
    [idTempatTidur]         INT            IDENTITY (1, 1) NOT NULL,
    [idRuanganRawatInap]    INT            NOT NULL,
    [noTempatTidur]         INT            NOT NULL,
    [kapasitas]             INT            CONSTRAINT [DF_masterRuanganTempatTidur_kapasitas] DEFAULT ((1)) NOT NULL,
    [flagMasihDigunakan]    BIT            CONSTRAINT [DF_masterRuanganTempatTidur_flagMasihDigunakan] DEFAULT ((1)) NOT NULL,
    [keteranganTempatTidur] NVARCHAR (MAX) NOT NULL,
    [tanggalDigunakan]      DATE           NULL,
    [tanggalNonaktif]       DATE           NULL,
    CONSTRAINT [PK_masterRuanganTempatTidur] PRIMARY KEY CLUSTERED ([idTempatTidur] ASC),
    CONSTRAINT [FK_masterRuanganTempatTidur_masterRuangan] FOREIGN KEY ([idRuanganRawatInap]) REFERENCES [dbo].[masterRuanganRawatInap] ([idRuanganRawatInap]) ON UPDATE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_masterRuanganTempatTidur_idRuanganRawatInap]
    ON [dbo].[masterRuanganTempatTidur]([idRuanganRawatInap] ASC, [tanggalDigunakan] ASC, [tanggalNonaktif] ASC);

