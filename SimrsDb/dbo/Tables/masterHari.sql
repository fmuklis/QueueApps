CREATE TABLE [dbo].[masterHari] (
    [idHari]   INT           IDENTITY (1, 1) NOT NULL,
    [namaHari] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterHari] PRIMARY KEY CLUSTERED ([idHari] ASC)
);

