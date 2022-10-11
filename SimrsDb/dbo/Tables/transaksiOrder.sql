CREATE TABLE [dbo].[transaksiOrder] (
    [idOrder]                       BIGINT         IDENTITY (1, 1) NOT NULL,
    [idDokter]                      INT            NULL,
    [tglOrder]                      DATETIME       NOT NULL,
    [kodeOrder]                     VARCHAR (50)   NULL,
    [nomorLabor]                    VARCHAR (50)   NULL,
    [nomorRadiologi]                VARCHAR (50)   NULL,
    [nomorUtdrs]                    VARCHAR (50)   NULL,
    [idPasienLuar]                  BIGINT         NULL,
    [idPendaftaranPasien]           BIGINT         NULL,
    [idRuanganAsal]                 INT            NULL,
    [idRuanganTujuan]               INT            NOT NULL,
    [idUserTerima]                  INT            NULL,
    [keterangan]                    NVARCHAR (MAX) NULL,
    [tanggalSampel]                 DATETIME       NULL,
    [idUserOtorisasi]               INT            NULL,
    [tanggalHasil]                  DATETIME       NULL,
    [idPenanggungjawabLaboratorium] INT            NULL,
    [keteranganHasilPemeriksaan]    NVARCHAR (MAX) NULL,
    [idStatusOrder]                 TINYINT        CONSTRAINT [DF_transaksiOrder_idStatusOrder] DEFAULT ((1)) NOT NULL,
    [tanggalModifikasi]             DATE           NULL,
    [idUserEntry]                   INT            NOT NULL,
    [tanggalEntry]                  DATETIME       CONSTRAINT [DF_transaksiOrder_tglEntry] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_transaksiOrder] PRIMARY KEY CLUSTERED ([idOrder] ASC),
    CONSTRAINT [FK_transaksiOrder_masterOperator] FOREIGN KEY ([idDokter]) REFERENCES [dbo].[masterOperator] ([idOperator]),
    CONSTRAINT [FK_transaksiOrder_masterOperatorPenanggungjawab] FOREIGN KEY ([idPenanggungjawabLaboratorium]) REFERENCES [dbo].[masterOperator] ([idOperator]),
    CONSTRAINT [FK_transaksiOrder_masterPasienLuar] FOREIGN KEY ([idPasienLuar]) REFERENCES [dbo].[masterPasienLuar] ([idPasienLuar]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_transaksiOrder_masterRuangan] FOREIGN KEY ([idRuanganAsal]) REFERENCES [dbo].[masterRuangan] ([idRuangan]),
    CONSTRAINT [FK_transaksiOrder_masterRuangan1] FOREIGN KEY ([idRuanganTujuan]) REFERENCES [dbo].[masterRuangan] ([idRuangan]),
    CONSTRAINT [FK_transaksiOrder_transaksiPendaftaranPasien] FOREIGN KEY ([idPendaftaranPasien]) REFERENCES [dbo].[transaksiPendaftaranPasien] ([idPendaftaranPasien]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiOrder_idPendaftaranPasien]
    ON [dbo].[transaksiOrder]([idPendaftaranPasien] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiOrder_idPasienLuar]
    ON [dbo].[transaksiOrder]([idPasienLuar] ASC);

