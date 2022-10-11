CREATE TABLE [dbo].[farmasiTPO] (
    [idTPO]      INT           IDENTITY (1, 1) NOT NULL,
    [namaTPO]    NVARCHAR (50) NULL,
    [idJenisTPO] INT           NULL,
    [idGudang]   INT           NULL,
    CONSTRAINT [PK_farmasiTPO] PRIMARY KEY CLUSTERED ([idTPO] ASC),
    CONSTRAINT [FK_farmasiTPO_farmasiMasterGudang] FOREIGN KEY ([idGudang]) REFERENCES [dbo].[farmasiMasterGudang] ([idGudang]) ON DELETE CASCADE ON UPDATE CASCADE
);

