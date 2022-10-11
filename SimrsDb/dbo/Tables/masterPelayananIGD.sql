CREATE TABLE [dbo].[masterPelayananIGD] (
    [idPelayananIGD]   TINYINT       IDENTITY (1, 1) NOT NULL,
    [namaPelayananIGD] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterJenisPelayananIGD] PRIMARY KEY CLUSTERED ([idPelayananIGD] ASC)
);

