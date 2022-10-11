CREATE TABLE [dbo].[transaksiOrderOK] (
    [idTransaksiOrderOK]  INT            IDENTITY (1, 1) NOT NULL,
    [idPendaftaranPasien] BIGINT         NOT NULL,
    [idUserEntry]         INT            NOT NULL,
    [idStatusOrderOK]     INT            NOT NULL,
    [idRuanganAsal]       INT            NOT NULL,
    [tglOrder]            DATETIME       NOT NULL,
    [tglEntry]            DATETIME       NOT NULL,
    [keterangan]          NVARCHAR (MAX) NULL,
    [tglOperasi]          DATE           NULL,
    [jamMulai]            TIME (0)       NULL,
    [jamSelesai]          TIME (0)       NULL,
    [tglAnestesi]         DATE           NULL,
    [jamMulaiAnestesi]    TIME (0)       NULL,
    [jamSelesaiAnestesi]  TIME (0)       NULL,
    [idGolonganOk]        INT            NULL,
    [idGolonganSpinal]    INT            NULL,
    [idGolonganSpesialis] INT            NULL,
    [idOperator]          INT            NULL,
    [tglJadwal]           SMALLDATETIME  NULL,
    [kodeoBooking]        VARCHAR (50)   NULL,
    [rencanaTindakan]     VARCHAR (255)  NULL,
    CONSTRAINT [PK_transaksiOrderOK] PRIMARY KEY CLUSTERED ([idTransaksiOrderOK] ASC),
    CONSTRAINT [FK_transaksiOrderOK_masterOkGolongan] FOREIGN KEY ([idGolonganOk]) REFERENCES [dbo].[masterOkGolongan] ([idGolonganOk]),
    CONSTRAINT [FK_transaksiOrderOK_masterOkGolonganSpesialis] FOREIGN KEY ([idGolonganSpesialis]) REFERENCES [dbo].[masterOkGolonganSpesialis] ([idGolonganSpesialis]),
    CONSTRAINT [FK_transaksiOrderOK_masterOkGolonganSpinal] FOREIGN KEY ([idGolonganSpinal]) REFERENCES [dbo].[masterOkGolonganSpinal] ([idGolonganSpinal]),
    CONSTRAINT [FK_transaksiOrderOK_masterOperator] FOREIGN KEY ([idOperator]) REFERENCES [dbo].[masterOperator] ([idOperator]),
    CONSTRAINT [FK_transaksiOrderOK_transaksiPendaftaranPasien] FOREIGN KEY ([idPendaftaranPasien]) REFERENCES [dbo].[transaksiPendaftaranPasien] ([idPendaftaranPasien])
);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiOrderOK_idPendaftaranPasien]
    ON [dbo].[transaksiOrderOK]([idPendaftaranPasien] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiOrderOK_tglOperasi]
    ON [dbo].[transaksiOrderOK]([tglOperasi] ASC);

