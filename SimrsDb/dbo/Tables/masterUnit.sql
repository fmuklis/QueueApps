CREATE TABLE [dbo].[masterUnit] (
    [idUnit]   INT           IDENTITY (1, 1) NOT NULL,
    [namaUnit] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterUnit] PRIMARY KEY CLUSTERED ([idUnit] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_masterUnit]
    ON [dbo].[masterUnit]([namaUnit] ASC);

