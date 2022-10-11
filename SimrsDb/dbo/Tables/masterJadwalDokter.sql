CREATE TABLE [dbo].[masterJadwalDokter] (
    [idJadwalDokter] INT      IDENTITY (1, 1) NOT NULL,
    [idRuangan]      INT      NOT NULL,
    [idOperator]     INT      NOT NULL,
    [idHari]         INT      NOT NULL,
    [jamMulai]       TIME (7) NULL,
    [jamSelesai]     TIME (7) NULL,
    CONSTRAINT [PK_masterJadwalDokter] PRIMARY KEY CLUSTERED ([idJadwalDokter] ASC),
    CONSTRAINT [FK_masterJadwalDokter_masterHari] FOREIGN KEY ([idHari]) REFERENCES [dbo].[masterHari] ([idHari]),
    CONSTRAINT [FK_masterJadwalDokter_masterJadwalDokter] FOREIGN KEY ([idJadwalDokter]) REFERENCES [dbo].[masterJadwalDokter] ([idJadwalDokter]),
    CONSTRAINT [FK_masterJadwalDokter_masterRuangan] FOREIGN KEY ([idRuangan]) REFERENCES [dbo].[masterRuangan] ([idRuangan])
);

