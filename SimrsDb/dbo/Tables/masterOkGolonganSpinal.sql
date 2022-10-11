CREATE TABLE [dbo].[masterOkGolonganSpinal] (
    [idGolonganSpinal] INT           IDENTITY (1, 1) NOT NULL,
    [golonganSpinal]   NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterOkGolonganSpinal] PRIMARY KEY CLUSTERED ([idGolonganSpinal] ASC)
);

