CREATE TABLE [dbo].[masterParamedisJenis] (
    [idJenisParamedis]   INT           IDENTITY (1, 1) NOT NULL,
    [namaJenisParamedis] NVARCHAR (50) NULL,
    CONSTRAINT [PK_masterParamedisJenis] PRIMARY KEY CLUSTERED ([idJenisParamedis] ASC)
);

