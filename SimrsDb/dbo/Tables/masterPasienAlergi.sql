CREATE TABLE [dbo].[masterPasienAlergi] (
    [idAlergiPasien] INT           IDENTITY (1, 1) NOT NULL,
    [idPasien]       BIGINT        NOT NULL,
    [idJenisAlergi]  TINYINT       NOT NULL,
    [alergiPasien]   VARCHAR (100) NOT NULL,
    [idUserEntry]    INT           NOT NULL,
    [tanggalEntry]   SMALLDATETIME CONSTRAINT [DF_alergiPasien_tanggalEntry] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_masterPasienAlergi] PRIMARY KEY CLUSTERED ([idAlergiPasien] ASC),
    CONSTRAINT [FK_alergiPasien_constJenisAlergi] FOREIGN KEY ([idJenisAlergi]) REFERENCES [dbo].[constJenisAlergi] ([idJenisAlergi]),
    CONSTRAINT [FK_alergiPasien_masterUser] FOREIGN KEY ([idUserEntry]) REFERENCES [dbo].[masterUser] ([idUser]),
    CONSTRAINT [FK_masterPasienAlergi_masterPasien] FOREIGN KEY ([idPasien]) REFERENCES [dbo].[masterPasien] ([idPasien])
);


GO
CREATE NONCLUSTERED INDEX [IX_masterPasienAlergi_idPasien_idJenisAlergi]
    ON [dbo].[masterPasienAlergi]([idPasien] ASC, [idJenisAlergi] ASC);

