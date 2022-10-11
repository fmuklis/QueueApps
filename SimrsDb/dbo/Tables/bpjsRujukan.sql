CREATE TABLE [dbo].[bpjsRujukan] (
    [idRujukan]        BIGINT        IDENTITY (1, 1) NOT NULL,
    [nomorSep]         VARCHAR (50)  NOT NULL,
    [nomorRujukan]     VARCHAR (50)  NULL,
    [tanggalRujukan]   DATE          NOT NULL,
    [kodeFaskes]       VARCHAR (50)  NULL,
    [kodePpkDirujuk]   VARCHAR (50)  NOT NULL,
    [jenisPelayanan]   TINYINT       NOT NULL,
    [catatan]          VARCHAR (500) NOT NULL,
    [idMasterICD]      INT           NOT NULL,
    [tipeRujukan]      TINYINT       NOT NULL,
    [kodePoliRujukan]  VARCHAR (50)  NOT NULL,
    [tanggalEntry]     DATETIME      CONSTRAINT [DF_bpjsRujukan_tanggalEntry] DEFAULT (getdate()) NOT NULL,
    [tanggalKunjungan] DATE          NULL,
    CONSTRAINT [PK_bpjsRujukan] PRIMARY KEY CLUSTERED ([idRujukan] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_bpjsRujukan_nomorSep]
    ON [dbo].[bpjsRujukan]([nomorSep] ASC);

