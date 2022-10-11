CREATE TABLE [dbo].[masterICDClassification] (
    [idICDClassification] INT            NOT NULL,
    [ICDClassification]   NVARCHAR (255) NOT NULL,
    [description]         NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_masterICDClassificationNew] PRIMARY KEY CLUSTERED ([idICDClassification] ASC)
);

