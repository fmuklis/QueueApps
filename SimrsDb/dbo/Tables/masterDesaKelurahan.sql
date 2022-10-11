CREATE TABLE [dbo].[masterDesaKelurahan] (
    [idDesaKelurahan]   INT           IDENTITY (1, 1) NOT NULL,
    [namaDesaKelurahan] NVARCHAR (50) NOT NULL,
    [idKecamatan]       INT           NOT NULL,
    CONSTRAINT [PK_masterDesaKelurahanPasien] PRIMARY KEY CLUSTERED ([idDesaKelurahan] ASC),
    CONSTRAINT [FK_masterDesaKelurahanPasien_masterKecamatanPasien] FOREIGN KEY ([idKecamatan]) REFERENCES [dbo].[masterKecamatan] ([idKecamatan]) ON DELETE CASCADE ON UPDATE CASCADE
);

