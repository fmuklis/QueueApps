CREATE TABLE [dbo].[masterStatusPasien] (
    [idStatusPasien]      TINYINT       NOT NULL,
    [idStatusPendaftaran] INT           NULL,
    [namaStatusPasien]    NVARCHAR (50) NOT NULL,
    [idStatusEklaim]      TINYINT       NOT NULL,
    [idStatusKeluar]      TINYINT       NULL,
    CONSTRAINT [PK_masterStatusPasien] PRIMARY KEY CLUSTERED ([idStatusPasien] ASC)
);

