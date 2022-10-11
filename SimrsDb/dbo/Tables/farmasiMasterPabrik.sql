CREATE TABLE [dbo].[farmasiMasterPabrik] (
    [idPabrik]     INT            IDENTITY (1, 1) NOT NULL,
    [namaPabrik]   NVARCHAR (250) NOT NULL,
    [alamatPabrik] NVARCHAR (MAX) NOT NULL,
    [telp]         NVARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_farmasiMasterPabrik] PRIMARY KEY CLUSTERED ([idPabrik] ASC)
);

