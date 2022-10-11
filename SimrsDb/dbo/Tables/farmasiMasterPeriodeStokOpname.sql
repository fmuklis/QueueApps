CREATE TABLE [dbo].[farmasiMasterPeriodeStokOpname] (
    [idPeriodeStokOpname] INT IDENTITY (1, 1) NOT NULL,
    [tahun]               INT NOT NULL,
    [bulan]               INT NOT NULL,
    CONSTRAINT [PK_farmasiMasterPeriodeStokOpname] PRIMARY KEY CLUSTERED ([idPeriodeStokOpname] ASC)
);

