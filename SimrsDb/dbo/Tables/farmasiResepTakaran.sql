CREATE TABLE [dbo].[farmasiResepTakaran] (
    [idTakaran]   INT            IDENTITY (1, 1) NOT NULL,
    [namaTakaran] NVARCHAR (150) NOT NULL,
    CONSTRAINT [PK_farmasiResepSediaan] PRIMARY KEY CLUSTERED ([idTakaran] ASC)
);

