CREATE TABLE [dbo].[masterPekerjaan] (
    [idPekerjaan]   TINYINT       IDENTITY (1, 1) NOT NULL,
    [namaPekerjaan] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterPekerjaanPasien] PRIMARY KEY CLUSTERED ([idPekerjaan] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_masterPekerjaan]
    ON [dbo].[masterPekerjaan]([namaPekerjaan] ASC);

