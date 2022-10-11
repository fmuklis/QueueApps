CREATE TABLE [dbo].[farmasiReturDetail] (
    [idReturDetail]     BIGINT          IDENTITY (1, 1) NOT NULL,
    [idRetur]           BIGINT          NULL,
    [idObatDetail]      BIGINT          NULL,
    [idPenjualanDetail] BIGINT          NULL,
    [jumlahAsal]        DECIMAL (18, 2) NOT NULL,
    [jumlahRetur]       DECIMAL (18, 2) NOT NULL,
    [tglRetur]          DATE            NULL,
    [tglEntry]          DATETIME        NULL,
    [idUserEntry]       INT             NULL,
    [valid]             BIT             CONSTRAINT [DF_farmasiReturDetail_valid] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_farmasiReturDetail] PRIMARY KEY CLUSTERED ([idReturDetail] ASC),
    CONSTRAINT [FK_farmasiReturDetail_farmasiMasterObatDetail] FOREIGN KEY ([idObatDetail]) REFERENCES [dbo].[farmasiMasterObatDetail] ([idObatDetail]),
    CONSTRAINT [FK_farmasiReturDetail_farmasiPenjualanDetail] FOREIGN KEY ([idPenjualanDetail]) REFERENCES [dbo].[farmasiPenjualanDetail] ([idPenjualanDetail]),
    CONSTRAINT [FK_farmasiReturDetail_farmasiRetur] FOREIGN KEY ([idRetur]) REFERENCES [dbo].[farmasiRetur] ([idRetur]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiReturDetail_idRetur]
    ON [dbo].[farmasiReturDetail]([idRetur] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiReturDetail_idObatDetail]
    ON [dbo].[farmasiReturDetail]([idObatDetail] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiReturDetail_idPenjualanDetail]
    ON [dbo].[farmasiReturDetail]([idPenjualanDetail] ASC);

