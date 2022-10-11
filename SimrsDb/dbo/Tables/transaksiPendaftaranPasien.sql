CREATE TABLE [dbo].[transaksiPendaftaranPasien] (
    [idPendaftaranPasien]               BIGINT        IDENTITY (1, 1) NOT NULL,
    [noReg]                             VARCHAR (50)  NULL,
    [idPendaftaranIbu]                  BIGINT        NULL,
    [idPasien]                          BIGINT        NOT NULL,
    [idJenisPendaftaran]                TINYINT       NOT NULL,
    [idJenisPerawatan]                  TINYINT       NOT NULL,
    [idAsalPasien]                      SMALLINT      NOT NULL,
    [idRuangan]                         SMALLINT      NULL,
    [idPelayananIGD]                    TINYINT       NULL,
    [idJenisPenjaminPembayaranPasien]   TINYINT       NULL,
    [tglDaftarPasien]                   DATETIME      NOT NULL,
    [tanggalRawatInap]                  DATETIME      NULL,
    [namaTempatAsalPasien]              VARCHAR (50)  NULL,
    [idTempatTidur]                     INT           NULL,
    [idStatusPendaftaran]               TINYINT       CONSTRAINT [DF_transaksiPendaftaranPasien_idStatusPendaftaran] DEFAULT ((1)) NOT NULL,
    [idKelas]                           TINYINT       CONSTRAINT [DF_transaksiPendaftaranPasien_idKelas] DEFAULT ((99)) NOT NULL,
    [idKelasPenjaminPembayaran]         TINYINT       NULL,
    [idDokter]                          INT           NULL,
    [namaPenanggungJawabPasien]         VARCHAR (50)  NULL,
    [idHubunganKeluargaPenanggungJawab] TINYINT       NULL,
    [alamatPenanggungJawabPasien]       VARCHAR (250) NULL,
    [noHpPenanggungJawab]               VARCHAR (50)  NULL,
    [flagBerkasTelahDikirim]            BIT           NULL,
    [idOrderRawatInap]                  BIGINT        CONSTRAINT [DF_transaksiPendaftaranPasien_idOrderRawatInap] DEFAULT ((1)) NOT NULL,
    [keluhan]                           VARCHAR (250) NULL,
    [idStatusPasien]                    TINYINT       NULL,
    [tglKontrol]                        DATE          NULL,
    [tglKeluarPasien]                   DATETIME      NULL,
    [rujukan]                           BIT           CONSTRAINT [DF_transaksiPendaftaranPasien_rujukan] DEFAULT ((0)) NULL,
    [flagBerkasTidakLengkap]            BIT           CONSTRAINT [DF_transaksiPendaftaranPasien_flagBerkasTidakLengkap] DEFAULT ((0)) NULL,
    [noSEPRawatInap]                    VARCHAR (50)  NULL,
    [noSEPRawatJalan]                   VARCHAR (50)  NULL,
    [keteranganPendaftaran]             VARCHAR (MAX) NULL,
    [anamnesa]                          VARCHAR (MAX) NULL,
    [keterangan]                        VARCHAR (MAX) NULL,
    [jenisDiet]                         VARCHAR (250) NULL,
    [keteranganDiet]                    VARCHAR (250) NULL,
    [depositRawatInap]                  MONEY         CONSTRAINT [DF_transaksiPendaftaranPasien_depositRawatInap] DEFAULT ((0)) NOT NULL,
    [depositKartuJaga]                  MONEY         CONSTRAINT [DF_transaksiPendaftaranPasien_depositKartuJaga] DEFAULT ((0)) NOT NULL,
    [tanggalModifikasi]                 DATE          NULL,
    [idUser]                            INT           NOT NULL,
    [tglEntry]                          DATETIME      CONSTRAINT [DF_transaksiPendaftaranPasien_tglEntry] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_transaksiPendaftaran] PRIMARY KEY CLUSTERED ([idPendaftaranPasien] ASC),
    CONSTRAINT [FK_transaksiPendaftaran_masterAsalPasien] FOREIGN KEY ([idAsalPasien]) REFERENCES [dbo].[masterAsalPasien] ([idAsalPasien]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_transaksiPendaftaran_masterPasien] FOREIGN KEY ([idPasien]) REFERENCES [dbo].[masterPasien] ([idPasien]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_transaksiPendaftaran_masterUser] FOREIGN KEY ([idUser]) REFERENCES [dbo].[masterUser] ([idUser]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_transaksiPendaftaranPasien_masterJenisPendaftaran] FOREIGN KEY ([idJenisPendaftaran]) REFERENCES [dbo].[masterJenisPendaftaran] ([idJenisPendaftaran]) ON UPDATE CASCADE,
    CONSTRAINT [FK_transaksiPendaftaranPasien_masterJenisPerawatan] FOREIGN KEY ([idJenisPerawatan]) REFERENCES [dbo].[masterJenisPerawatan] ([idJenisPerawatan]) ON UPDATE CASCADE,
    CONSTRAINT [FK_transaksiPendaftaranPasien_masterOperator] FOREIGN KEY ([idDokter]) REFERENCES [dbo].[masterOperator] ([idOperator]),
    CONSTRAINT [FK_transaksiPendaftaranPasien_masterPelayananIGD] FOREIGN KEY ([idPelayananIGD]) REFERENCES [dbo].[masterPelayananIGD] ([idPelayananIGD]),
    CONSTRAINT [FK_transaksiPendaftaranPasien_masterStatusPasien] FOREIGN KEY ([idStatusPasien]) REFERENCES [dbo].[masterStatusPasien] ([idStatusPasien]),
    CONSTRAINT [FK_transaksiPendaftaranPasien_masterStatusPendaftaran] FOREIGN KEY ([idStatusPendaftaran]) REFERENCES [dbo].[masterStatusPendaftaran] ([idStatusPendaftaran]) ON UPDATE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiPendaftaranPasien_idPasien]
    ON [dbo].[transaksiPendaftaranPasien]([idPasien] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiPendaftaranPasien_tglDaftarPasien]
    ON [dbo].[transaksiPendaftaranPasien]([tglDaftarPasien] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiPendaftaranPasien_idStatusPendaftaran]
    ON [dbo].[transaksiPendaftaranPasien]([idStatusPendaftaran] ASC, [idJenisPerawatan] ASC, [idRuangan] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiPendaftaranPasien_idStatusPasien]
    ON [dbo].[transaksiPendaftaranPasien]([idStatusPasien] ASC);

