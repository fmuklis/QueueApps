CREATE TABLE [dbo].[masterAsalPasienJenis] (
    [idJenisFaskes] INT           NOT NULL,
    [jenisFaskes]   NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterAsalPasienJenis] PRIMARY KEY CLUSTERED ([idJenisFaskes] ASC)
);

