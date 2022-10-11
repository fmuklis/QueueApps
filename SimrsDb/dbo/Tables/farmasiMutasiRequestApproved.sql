CREATE TABLE [dbo].[farmasiMutasiRequestApproved] (
    [idMutasiRequestApproved] BIGINT          IDENTITY (1, 1) NOT NULL,
    [idItemOrderMutasi]       BIGINT          NOT NULL,
    [idObatDetail]            BIGINT          NOT NULL,
    [jumlahDisetujui]         DECIMAL (18, 2) NOT NULL,
    [idUserEntry]             INT             NULL,
    CONSTRAINT [PK_farmasiMutasiRequestApproved] PRIMARY KEY CLUSTERED ([idMutasiRequestApproved] ASC),
    CONSTRAINT [FK_farmasiMutasiRequestApproved_farmasiMasterObatDetail] FOREIGN KEY ([idObatDetail]) REFERENCES [dbo].[farmasiMasterObatDetail] ([idObatDetail]),
    CONSTRAINT [FK_farmasiMutasiRequestApproved_masterUser] FOREIGN KEY ([idUserEntry]) REFERENCES [dbo].[masterUser] ([idUser])
);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiMutasiDetail_idObatDetail]
    ON [dbo].[farmasiMutasiRequestApproved]([idObatDetail] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_farmasiMutasiDetail_idItemOrderMutasi]
    ON [dbo].[farmasiMutasiRequestApproved]([idItemOrderMutasi] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_farmasiMutasiRequestApproved_idIom_idOd]
    ON [dbo].[farmasiMutasiRequestApproved]([idItemOrderMutasi] ASC, [idObatDetail] ASC);

