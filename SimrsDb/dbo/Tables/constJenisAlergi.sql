CREATE TABLE [dbo].[constJenisAlergi] (
    [idJenisAlergi] TINYINT      NOT NULL,
    [jenisAlergi]   VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_constJenisAlergi] PRIMARY KEY CLUSTERED ([idJenisAlergi] ASC)
);

