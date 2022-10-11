CREATE TABLE [dbo].[farmasiResepDetail] (
    [idResepDetail]  BIGINT          IDENTITY (1, 1) NOT NULL,
    [idResep]        BIGINT          NOT NULL,
    [idObatDosis]    INT             NOT NULL,
    [idRacikan]      INT             CONSTRAINT [DF_farmasiResepDetail_idRacikan] DEFAULT ((0)) NOT NULL,
    [idKemasan]      INT             NULL,
    [jumlah]         DECIMAL (18, 2) NOT NULL,
    [jumlahKemasan]  DECIMAL (18, 2) NULL,
    [kaliKonsumsi]   INT             NULL,
    [jumlahKonsumsi] NVARCHAR (50)   NULL,
    [idTakaran]      INT             NULL,
    [idResepWaktu]   INT             NULL,
    [keterangan]     NVARCHAR (250)  NULL,
    [idSaatKonsumsi] INT             NULL,
    [idUserEntry]    INT             NULL,
    CONSTRAINT [PK_farmasiResepDetail] PRIMARY KEY CLUSTERED ([idResepDetail] ASC),
    CONSTRAINT [FK_farmasiResepDetail_farmasiResep] FOREIGN KEY ([idResep]) REFERENCES [dbo].[farmasiResep] ([idResep]) ON DELETE CASCADE,
    CONSTRAINT [FK_farmasiResepDetail_farmasiResepSaatKonsumsi] FOREIGN KEY ([idSaatKonsumsi]) REFERENCES [dbo].[farmasiResepSaatKonsumsi] ([idSaatKonsumsi])
);

