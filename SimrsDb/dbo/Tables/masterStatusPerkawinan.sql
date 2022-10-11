CREATE TABLE [dbo].[masterStatusPerkawinan] (
    [idStatusPerkawinan]   TINYINT       IDENTITY (1, 1) NOT NULL,
    [namaStatusPerkawinan] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterStatusPerkawinanPasien] PRIMARY KEY CLUSTERED ([idStatusPerkawinan] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_masterStatusPerkawinan]
    ON [dbo].[masterStatusPerkawinan]([namaStatusPerkawinan] ASC);

