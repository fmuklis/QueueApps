CREATE TABLE [dbo].[masterOkGolongan] (
    [idGolonganOk] INT           IDENTITY (1, 1) NOT NULL,
    [golonganOk]   NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterOkGolongan] PRIMARY KEY CLUSTERED ([idGolonganOk] ASC)
);

