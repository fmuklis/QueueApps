CREATE TABLE [dbo].[masterKabupaten] (
    [idKabupaten]   INT           IDENTITY (1, 1) NOT NULL,
    [namaKabupaten] NVARCHAR (50) NOT NULL,
    [idProvinsi]    INT           NOT NULL,
    [flagDefault]   BIT           CONSTRAINT [DF_masterKabupaten_flagDefault] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_masterKabupatenPasien] PRIMARY KEY CLUSTERED ([idKabupaten] ASC),
    CONSTRAINT [FK_masterKabupatenPasien_masterProvinsiPasien] FOREIGN KEY ([idProvinsi]) REFERENCES [dbo].[masterProvinsi] ([idProvinsi]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_masterKabupatenPasien]
    ON [dbo].[masterKabupaten]([namaKabupaten] ASC, [idProvinsi] ASC);

