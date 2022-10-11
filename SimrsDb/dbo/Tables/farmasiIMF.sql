CREATE TABLE [dbo].[farmasiIMF] (
    [idIMF]               BIGINT        IDENTITY (1, 1) NOT NULL,
    [noIMF]               NVARCHAR (50) NULL,
    [idPendaftaranPasien] INT           NOT NULL,
    [idRuangan]           INT           NOT NULL,
    [idDokter]            INT           NOT NULL,
    [tglIMF]              DATE          NOT NULL,
    [tglEntry]            DATETIME      CONSTRAINT [DF_farmasiIMF_tglEntry] DEFAULT (getdate()) NOT NULL,
    [idUserEntry]         INT           NOT NULL,
    CONSTRAINT [PK_farmasiIMF] PRIMARY KEY CLUSTERED ([idIMF] ASC)
);

