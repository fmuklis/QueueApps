CREATE TABLE [dbo].[masterKeadaanPasien] (
    [idKeadaanPasien]   INT           IDENTITY (1, 1) NOT NULL,
    [namaKeadaanPasien] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterKeadaanPasien] PRIMARY KEY CLUSTERED ([idKeadaanPasien] ASC)
);

