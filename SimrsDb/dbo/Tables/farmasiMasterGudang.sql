CREATE TABLE [dbo].[farmasiMasterGudang] (
    [idGudang]   INT           IDENTITY (1, 1) NOT NULL,
    [namaGudang] NVARCHAR (50) NULL,
    CONSTRAINT [PK_farmasiMasterGudang] PRIMARY KEY CLUSTERED ([idGudang] ASC)
);

