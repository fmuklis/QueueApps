CREATE TABLE [dbo].[transaksiBillingHeader] (
    [idBilling]             BIGINT          IDENTITY (1, 1) NOT NULL,
    [kodeBayar]             VARCHAR (50)    NOT NULL,
    [idPendaftaranPasien]   BIGINT          NULL,
    [idDokter]              INT             NULL,
    [idRuangan]             INT             NULL,
    [idPasienLuar]          BIGINT          NULL,
    [idResep]               BIGINT          NULL,
    [idOrder]               BIGINT          NULL,
    [idJenisBilling]        SMALLINT        NOT NULL,
    [idJenisBayar]          INT             NULL,
    [tglBayar]              DATETIME        NULL,
    [idUserBayar]           INT             NULL,
    [idStatusBayar]         TINYINT         CONSTRAINT [DF_transaksiBillingHeader_idStatusBayar] DEFAULT ((1)) NOT NULL,
    [diskonTunai]           DECIMAL (18, 2) CONSTRAINT [DF_transaksiBillingHeader_diskonTunai] DEFAULT ((0)) NOT NULL,
    [diskonPersen]          DECIMAL (18, 2) CONSTRAINT [DF_transaksiBillingHeader_diskonPersen] DEFAULT ((0)) NOT NULL,
    [nilaiBayar]            MONEY           CONSTRAINT [DF_transaksiBillingHeader_nilaiBayar] DEFAULT ((0)) NULL,
    [keterangan]            NVARCHAR (MAX)  NULL,
    [idUserEntry]           INT             NULL,
    [tanggalEntry]          DATETIME        CONSTRAINT [DF_transaksiBillingHeader_tanggalEntry] DEFAULT (getdate()) NOT NULL,
    [tanggalModifikasi]     DATE            NULL,
    [idStatusKlaim]         TINYINT         NULL,
    [cbgKode]               NCHAR (50)      NULL,
    [cbgDescription]        NCHAR (250)     NULL,
    [cbgTarif]              MONEY           NULL,
    [subAcuteKode]          NCHAR (50)      NULL,
    [subAcuteDescription]   NCHAR (250)     NULL,
    [subAcuteTarif]         MONEY           NULL,
    [chronicKode]           NCHAR (50)      NULL,
    [chronicDescription]    NCHAR (250)     NULL,
    [chronicTarif]          MONEY           NULL,
    [kelasEksekutif]        BIT             NULL,
    [tarifPoliEksekutif]    MONEY           NULL,
    [tarifProsedurNonBedah] MONEY           NULL,
    [tarifProsedurBedah]    MONEY           NULL,
    [tarifKonsultasi]       MONEY           NULL,
    [tarifTenagaAhli]       MONEY           NULL,
    [tarifKeperawatan]      MONEY           NULL,
    [tarifPenunjang]        MONEY           NULL,
    [tarifRadiologi]        MONEY           NULL,
    [tarifLaboratorium]     MONEY           NULL,
    [tarifPelayananDarah]   MONEY           NULL,
    [tarifRehabilitasi]     MONEY           NULL,
    [tarifKamarAkomodasi]   MONEY           NULL,
    [tarifRawatIntensif]    MONEY           NULL,
    [tarifObat]             MONEY           NULL,
    [tarifObatKronis]       MONEY           NULL,
    [tarifObatKemoterapi]   MONEY           NULL,
    [tarifAlkes]            MONEY           NULL,
    [tarifBMHP]             MONEY           NULL,
    [tarifSewaAlat]         MONEY           NULL,
    [rawatIntensif]         BIT             NULL,
    [pemakaianVentilator]   NUMERIC (18, 2) NULL,
    [lamaRawatIntensif]     SMALLINT        NULL,
    [lamaRawatInap]         SMALLINT        NULL,
    [attachment]            VARCHAR (50)    NULL,
    CONSTRAINT [PK_transaksiBillingHeader] PRIMARY KEY CLUSTERED ([idBilling] ASC),
    CONSTRAINT [FK_transaksiBillingHeader_masterJenisBayar] FOREIGN KEY ([idJenisBayar]) REFERENCES [dbo].[masterJenisBayar] ([idJenisBayar]),
    CONSTRAINT [FK_transaksiBillingHeader_masterJenisBilling] FOREIGN KEY ([idJenisBilling]) REFERENCES [dbo].[masterJenisBilling] ([idJenisBilling]),
    CONSTRAINT [FK_transaksiBillingHeader_masterOperator] FOREIGN KEY ([idDokter]) REFERENCES [dbo].[masterOperator] ([idOperator]),
    CONSTRAINT [FK_transaksiBillingHeader_masterPasienLuar] FOREIGN KEY ([idPasienLuar]) REFERENCES [dbo].[masterPasienLuar] ([idPasienLuar]),
    CONSTRAINT [FK_transaksiBillingHeader_masterRuangan] FOREIGN KEY ([idRuangan]) REFERENCES [dbo].[masterRuangan] ([idRuangan]),
    CONSTRAINT [FK_transaksiBillingHeader_masterStatusBayar] FOREIGN KEY ([idStatusBayar]) REFERENCES [dbo].[masterStatusBayar] ([idStatusBayar]),
    CONSTRAINT [FK_transaksiBillingHeader_masterStatusKlaim] FOREIGN KEY ([idStatusKlaim]) REFERENCES [dbo].[masterStatusKlaim] ([idStatusKlaim]),
    CONSTRAINT [FK_transaksiBillingHeader_masterUser] FOREIGN KEY ([idUserEntry]) REFERENCES [dbo].[masterUser] ([idUser]),
    CONSTRAINT [FK_transaksiBillingHeader_masterUser1] FOREIGN KEY ([idUserBayar]) REFERENCES [dbo].[masterUser] ([idUser]),
    CONSTRAINT [FK_transaksiBillingHeader_transaksiPendaftaranPasien] FOREIGN KEY ([idPendaftaranPasien]) REFERENCES [dbo].[transaksiPendaftaranPasien] ([idPendaftaranPasien])
);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiBillingHeader_idPendaftaranPasien]
    ON [dbo].[transaksiBillingHeader]([idPendaftaranPasien] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiBillingHeader_idPasienLuar]
    ON [dbo].[transaksiBillingHeader]([idPasienLuar] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiBillingHeader_idResep]
    ON [dbo].[transaksiBillingHeader]([idResep] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiBillingHeader_idOrder]
    ON [dbo].[transaksiBillingHeader]([idOrder] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiBillingHeader_idJenisBilling]
    ON [dbo].[transaksiBillingHeader]([idJenisBilling] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiBillingHeader_idStatusBayar]
    ON [dbo].[transaksiBillingHeader]([idStatusBayar] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiBillingHeader_idJenisBillingWithInclude]
    ON [dbo].[transaksiBillingHeader]([idJenisBilling] ASC)
    INCLUDE([idPendaftaranPasien], [idStatusBayar], [tanggalModifikasi]);

