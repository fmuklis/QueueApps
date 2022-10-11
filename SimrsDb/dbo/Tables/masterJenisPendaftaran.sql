CREATE TABLE [dbo].[masterJenisPendaftaran] (
    [idJenisPendaftaran]   TINYINT       NOT NULL,
    [namaJenisPendaftaran] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterJenisPendaftaran] PRIMARY KEY CLUSTERED ([idJenisPendaftaran] ASC)
);

