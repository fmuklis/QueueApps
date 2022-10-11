CREATE TABLE [dbo].[masterDiagnosaGolonganPenyakit] (
    [idGolonganPenyakit] INT            IDENTITY (1, 1) NOT NULL,
    [golonganPenyakit]   NVARCHAR (250) NOT NULL,
    CONSTRAINT [PK_masterDiagnosaGolonganPenyakit] PRIMARY KEY CLUSTERED ([idGolonganPenyakit] ASC)
);

