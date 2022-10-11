CREATE TABLE [dbo].[masterPengobatan] (
    [idPengobatan]   INT           IDENTITY (1, 1) NOT NULL,
    [namaPengobatan] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterPengobatan] PRIMARY KEY CLUSTERED ([idPengobatan] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_masterPengobatan]
    ON [dbo].[masterPengobatan]([namaPengobatan] ASC);

