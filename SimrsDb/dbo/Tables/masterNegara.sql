CREATE TABLE [dbo].[masterNegara] (
    [idNegara]    INT           IDENTITY (1, 1) NOT NULL,
    [namaNegara]  NVARCHAR (50) NOT NULL,
    [flagDefault] BIT           CONSTRAINT [DF_masterNegara_flagDefault] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_masterNegaraPasien] PRIMARY KEY CLUSTERED ([idNegara] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_masterNegara]
    ON [dbo].[masterNegara]([namaNegara] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_masterNegara_1]
    ON [dbo].[masterNegara]([idNegara] ASC);

