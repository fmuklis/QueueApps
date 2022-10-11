CREATE TABLE [dbo].[masterStatusPendaftaran] (
    [idStatusPendaftaran]   TINYINT       NOT NULL,
    [namaStatusPendaftaran] NVARCHAR (50) NOT NULL,
    [deskripsi]             NVARCHAR (50) NULL,
    CONSTRAINT [PK_masterStatusPendaftaran] PRIMARY KEY CLUSTERED ([idStatusPendaftaran] ASC)
);

