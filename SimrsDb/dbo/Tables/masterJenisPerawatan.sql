CREATE TABLE [dbo].[masterJenisPerawatan] (
    [idJenisPerawatan]   TINYINT        NOT NULL,
    [namaJenisPerawatan] NVARCHAR (100) NULL,
    CONSTRAINT [PK_masterJenisPerawatan] PRIMARY KEY CLUSTERED ([idJenisPerawatan] ASC)
);

