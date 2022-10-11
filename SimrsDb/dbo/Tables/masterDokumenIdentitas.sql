CREATE TABLE [dbo].[masterDokumenIdentitas] (
    [idDokumenIdentitas]   TINYINT       IDENTITY (1, 1) NOT NULL,
    [namaDokumenIdentitas] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterDokumenIdentitasPasien] PRIMARY KEY CLUSTERED ([idDokumenIdentitas] ASC)
);

