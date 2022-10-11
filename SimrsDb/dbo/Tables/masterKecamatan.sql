CREATE TABLE [dbo].[masterKecamatan] (
    [idKecamatan]   INT           IDENTITY (1, 1) NOT NULL,
    [namaKecamatan] NVARCHAR (50) NOT NULL,
    [idKabupaten]   INT           NOT NULL,
    CONSTRAINT [PK_masterKecamatanPasien] PRIMARY KEY CLUSTERED ([idKecamatan] ASC),
    CONSTRAINT [FK_masterKecamatanPasien_masterKabupatenPasien] FOREIGN KEY ([idKabupaten]) REFERENCES [dbo].[masterKabupaten] ([idKabupaten]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_masterKecamatanPasien]
    ON [dbo].[masterKecamatan]([namaKecamatan] ASC, [idKabupaten] ASC);

