CREATE TABLE [dbo].[masterAsalPasien] (
    [idAsalPasien]   SMALLINT      IDENTITY (1, 1) NOT NULL,
    [idJenisFaskes]  INT           NULL,
    [namaAsalPasien] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterAsalPasien] PRIMARY KEY CLUSTERED ([idAsalPasien] ASC),
    CONSTRAINT [FK_masterAsalPasien_masterAsalPasien] FOREIGN KEY ([idAsalPasien]) REFERENCES [dbo].[masterAsalPasien] ([idAsalPasien])
);

