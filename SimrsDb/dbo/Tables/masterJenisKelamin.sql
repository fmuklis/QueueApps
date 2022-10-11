CREATE TABLE [dbo].[masterJenisKelamin] (
    [idJenisKelamin]   TINYINT       NOT NULL,
    [namaJenisKelamin] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterJenisKelaminPasien] PRIMARY KEY CLUSTERED ([idJenisKelamin] ASC)
);

