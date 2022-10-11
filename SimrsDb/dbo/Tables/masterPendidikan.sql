CREATE TABLE [dbo].[masterPendidikan] (
    [idPendidikan]   TINYINT       IDENTITY (1, 1) NOT NULL,
    [namaPendidikan] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterPendidikanPasien] PRIMARY KEY CLUSTERED ([idPendidikan] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_masterPendidikan]
    ON [dbo].[masterPendidikan]([namaPendidikan] ASC);

