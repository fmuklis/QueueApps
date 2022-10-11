CREATE TABLE [dbo].[masterJenisTarif] (
    [idJenisTarif]       INT           IDENTITY (1, 1) NOT NULL,
    [namaJenisTarif]     NVARCHAR (50) NOT NULL,
    [captionLaporan]     NVARCHAR (50) NOT NULL,
    [idJenisPendaftaran] TINYINT       NOT NULL,
    CONSTRAINT [PK_masterJenisTarip] PRIMARY KEY CLUSTERED ([idJenisTarif] ASC),
    CONSTRAINT [FK_masterJenisTarip_masterJenisPendaftaran] FOREIGN KEY ([idJenisPendaftaran]) REFERENCES [dbo].[masterJenisPendaftaran] ([idJenisPendaftaran]) ON DELETE CASCADE ON UPDATE CASCADE
);

