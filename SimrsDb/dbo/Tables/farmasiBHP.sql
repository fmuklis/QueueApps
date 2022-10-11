CREATE TABLE [dbo].[farmasiBHP] (
    [idBHP]     INT IDENTITY (1, 1) NOT NULL,
    [idRuangan] INT NOT NULL,
    CONSTRAINT [PK_farmasiBHP] PRIMARY KEY CLUSTERED ([idBHP] ASC),
    CONSTRAINT [FK_farmasiBHP_masterRuangan] FOREIGN KEY ([idRuangan]) REFERENCES [dbo].[masterRuangan] ([idRuangan])
);

