CREATE TABLE [dbo].[masterDiagnosa] (
    [idMasterDiagnosa]   INT            IDENTITY (1, 1) NOT NULL,
    [idGolonganPenyakit] INT            NULL,
    [diagnosa]           NCHAR (250)    NOT NULL,
    [alias]              NVARCHAR (50)  NULL,
    [anamnesa]           NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_masterDiagnosa] PRIMARY KEY CLUSTERED ([idMasterDiagnosa] ASC),
    CONSTRAINT [FK_masterDiagnosa_masterDiagnosaGolonganPenyakit] FOREIGN KEY ([idGolonganPenyakit]) REFERENCES [dbo].[masterDiagnosaGolonganPenyakit] ([idGolonganPenyakit])
);


GO
CREATE NONCLUSTERED INDEX [diagnosa]
    ON [dbo].[masterDiagnosa]([diagnosa] ASC);


GO
CREATE NONCLUSTERED INDEX [alias]
    ON [dbo].[masterDiagnosa]([alias] ASC);

