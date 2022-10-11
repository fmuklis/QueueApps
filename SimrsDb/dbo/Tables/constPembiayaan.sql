CREATE TABLE [dbo].[constPembiayaan] (
    [idPembiayaan] TINYINT      NOT NULL,
    [pembiayaan]   VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_constPembiayaan] PRIMARY KEY CLUSTERED ([idPembiayaan] ASC)
);

