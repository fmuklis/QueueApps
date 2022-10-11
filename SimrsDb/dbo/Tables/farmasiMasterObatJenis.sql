CREATE TABLE [dbo].[farmasiMasterObatJenis] (
    [idJenisOBat]   INT            IDENTITY (1, 1) NOT NULL,
    [namaJenisObat] NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_farmasiMasterObatJenis] PRIMARY KEY CLUSTERED ([idJenisOBat] ASC)
);

