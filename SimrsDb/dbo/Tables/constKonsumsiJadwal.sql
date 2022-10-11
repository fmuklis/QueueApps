CREATE TABLE [dbo].[constKonsumsiJadwal] (
    [idJadwalKonsumsi] TINYINT      NOT NULL,
    [jadwalKonsumsi]   VARCHAR (50) NOT NULL,
    [jamKonnsumsi]     TIME (0)     NOT NULL,
    CONSTRAINT [PK_constKonsumsiJadwal] PRIMARY KEY CLUSTERED ([idJadwalKonsumsi] ASC)
);

