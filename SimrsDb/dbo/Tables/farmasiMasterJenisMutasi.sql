CREATE TABLE [dbo].[farmasiMasterJenisMutasi] (
    [idJenisMutasi] TINYINT      NOT NULL,
    [jenisMutasi]   VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_farmasiMasterJenisMutasi] PRIMARY KEY CLUSTERED ([idJenisMutasi] ASC)
);

