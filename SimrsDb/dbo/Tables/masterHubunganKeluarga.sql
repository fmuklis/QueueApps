CREATE TABLE [dbo].[masterHubunganKeluarga] (
    [idHubunganKeluarga]   INT           IDENTITY (1, 1) NOT NULL,
    [namaHubunganKeluarga] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterHubunganKeluarga] PRIMARY KEY CLUSTERED ([idHubunganKeluarga] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_masterHubunganKeluarga]
    ON [dbo].[masterHubunganKeluarga]([namaHubunganKeluarga] ASC);

