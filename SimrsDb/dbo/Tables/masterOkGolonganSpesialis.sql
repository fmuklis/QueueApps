CREATE TABLE [dbo].[masterOkGolonganSpesialis] (
    [idGolonganSpesialis] INT           IDENTITY (1, 1) NOT NULL,
    [golonganSpesialis]   NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterOkGolonganSpesialis] PRIMARY KEY CLUSTERED ([idGolonganSpesialis] ASC)
);

