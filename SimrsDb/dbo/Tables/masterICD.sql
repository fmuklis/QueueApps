CREATE TABLE [dbo].[masterICD] (
    [idMasterICD]             INT            IDENTITY (1, 1) NOT NULL,
    [idICDClassification]     INT            NULL,
    [idGolonganSebabPenyakit] INT            NULL,
    [ICD]                     NVARCHAR (50)  NOT NULL,
    [diagnosa]                NVARCHAR (MAX) NOT NULL,
    [keterangan]              NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_masterICD] PRIMARY KEY CLUSTERED ([idMasterICD] ASC),
    CONSTRAINT [FK_masterICD_masterGolonganSebabPenyakit] FOREIGN KEY ([idGolonganSebabPenyakit]) REFERENCES [dbo].[consGolonganSebabPenyakit] ([idGolonganSebabPenyakit]),
    CONSTRAINT [FK_masterICD_masterICDClassification] FOREIGN KEY ([idICDClassification]) REFERENCES [dbo].[masterICDClassification] ([idICDClassification])
);


GO
CREATE NONCLUSTERED INDEX [IX_masterICD_idGolonganSebabPenyakit]
    ON [dbo].[masterICD]([idGolonganSebabPenyakit] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_masterICD_ICD]
    ON [dbo].[masterICD]([ICD] ASC);

