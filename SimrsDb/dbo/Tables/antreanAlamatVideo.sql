CREATE TABLE [dbo].[antreanAlamatVideo] (
    [idVideo]     INT            IDENTITY (1, 1) NOT NULL,
    [alamatVideo] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_transaksiAntrianAlamatVideo] PRIMARY KEY CLUSTERED ([idVideo] ASC)
);

