CREATE TABLE [dbo].[masterJenisBayar] (
    [idJenisBayar]   INT           IDENTITY (1, 1) NOT NULL,
    [namaJenisBayar] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterJenisBayar] PRIMARY KEY CLUSTERED ([idJenisBayar] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_masterJenisBayar]
    ON [dbo].[masterJenisBayar]([namaJenisBayar] ASC);

