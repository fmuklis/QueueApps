CREATE TABLE [dbo].[farmasiJenisBayar] (
    [idJenisBayar]   INT           IDENTITY (1, 1) NOT NULL,
    [namaJenisBayar] NVARCHAR (50) NULL,
    CONSTRAINT [PK_farmasiJenisBayar] PRIMARY KEY CLUSTERED ([idJenisBayar] ASC)
);

