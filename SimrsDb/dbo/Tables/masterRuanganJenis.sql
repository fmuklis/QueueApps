CREATE TABLE [dbo].[masterRuanganJenis] (
    [idJenisRuangan]   INT           IDENTITY (1, 1) NOT NULL,
    [namaJenisRuangan] NVARCHAR (50) NULL,
    CONSTRAINT [PK_masterRuanganJenis_1] PRIMARY KEY CLUSTERED ([idJenisRuangan] ASC)
);

