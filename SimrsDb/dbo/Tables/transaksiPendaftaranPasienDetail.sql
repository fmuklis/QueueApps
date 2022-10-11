CREATE TABLE [dbo].[transaksiPendaftaranPasienDetail] (
    [idPendaftaranPasienDetail]    INT            IDENTITY (1, 1) NOT NULL,
    [idTransaksiOrderRawatInap]    BIGINT         NULL,
    [idPendaftaranPasien]          BIGINT         NOT NULL,
    [idStatusPendaftaranRawatInap] INT            CONSTRAINT [DF_transaksiPendaftaranPasienDetail_idStatusPendaftaranRawatInap] DEFAULT ((1)) NULL,
    [idTempatTidur]                INT            NULL,
    [idJenisPelayananRawatInap]    TINYINT        NULL,
    [tanggalMasuk]                 DATETIME       NULL,
    [tanggalKeluar]                DATETIME       NULL,
    [keterangan]                   NVARCHAR (MAX) NULL,
    [idMasterTarifKamar]           INT            NOT NULL,
    [hargaPokok]                   FLOAT (53)     CONSTRAINT [DF_transaksiPendaftaranPasienDetail_hargaPokok] DEFAULT ((0)) NOT NULL,
    [tarifKamar]                   FLOAT (53)     CONSTRAINT [DF_transaksiPendaftaranPasienDetail_tarifKamar] DEFAULT ((0)) NOT NULL,
    [lamaInap]                     AS             (case when [tanggalKeluar] IS NOT NULL then coalesce(nullif(datediff(day,[tanggalMasuk],[tanggalKeluar]),(0)),(1)) else coalesce(nullif(datediff(day,[tanggalMasuk],getdate()),(0)),(1)) end),
    [aktif]                        BIT            NULL,
    [ditagih]                      BIT            CONSTRAINT [DF_transaksiPendaftaranPasienDetail_ditagih] DEFAULT ((1)) NOT NULL,
    [biayaInap]                    AS             (case when [ditagih]=(1) AND [tanggalKeluar] IS NOT NULL then [tarifKamar]*coalesce(nullif(datediff(day,[tanggalMasuk],[tanggalKeluar]),(0)),(1)) when [ditagih]=(1) AND [tanggalKeluar] IS NULL then [tarifKamar]*coalesce(nullif(datediff(day,[tanggalMasuk],getdate()),(0)),(1)) else (0) end),
    [idUserEntry]                  INT            NULL,
    [tanggalEntry]                 DATETIME       CONSTRAINT [DF_transaksiPendaftaranPasienDetail_tanggalEntry] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_transaksiPendaftaranDetail] PRIMARY KEY CLUSTERED ([idPendaftaranPasienDetail] ASC),
    CONSTRAINT [FK_transaksiPendaftaranDetail_transaksiPendaftaranPasien1] FOREIGN KEY ([idPendaftaranPasien]) REFERENCES [dbo].[transaksiPendaftaranPasien] ([idPendaftaranPasien]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_transaksiPendaftaranPasienDetail_masterTarifKamar] FOREIGN KEY ([idMasterTarifKamar]) REFERENCES [dbo].[masterTarifKamar] ([idMasterTarifKamar]),
    CONSTRAINT [FK_transaksiPendaftaranPasienDetail_transaksiOrderRawatInap] FOREIGN KEY ([idTransaksiOrderRawatInap]) REFERENCES [dbo].[transaksiOrderRawatInap] ([idTransaksiOrderRawatInap])
);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiPendaftaranDetail_idPendaftaranPasien]
    ON [dbo].[transaksiPendaftaranPasienDetail]([idPendaftaranPasien] ASC, [idMasterTarifKamar] ASC, [idStatusPendaftaranRawatInap] ASC, [idTempatTidur] ASC, [idTransaksiOrderRawatInap] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiPendaftaranPasienDetail_idTransaksiOrderRawatInap]
    ON [dbo].[transaksiPendaftaranPasienDetail]([idTransaksiOrderRawatInap] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiPendaftaranPasienDetail_idTempatTidur]
    ON [dbo].[transaksiPendaftaranPasienDetail]([idTempatTidur] ASC);

