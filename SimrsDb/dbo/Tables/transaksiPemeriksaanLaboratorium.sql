CREATE TABLE [dbo].[transaksiPemeriksaanLaboratorium] (
    [idPemeriksaanLaboratorium]           BIGINT         IDENTITY (1, 1) NOT NULL,
    [idTindakanPasien]                    BIGINT         NOT NULL,
    [idDetailItemPemeriksaanLaboratorium] INT            NOT NULL,
    [nilai]                               NVARCHAR (225) NOT NULL,
    [satuan]                              VARCHAR (50)   NULL,
    [nilaiRujukan]                        NVARCHAR (500) NULL,
    [valid]                               BIT            CONSTRAINT [DF_transaksiPemeriksaanLaboratorium_valid] DEFAULT ((0)) NOT NULL,
    [idUserEntry]                         INT            NOT NULL,
    [tanggalEntry]                        DATETIME       CONSTRAINT [DF_transaksiPemeriksaanLaboratorium_tanggalEntry] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_transaksiPemeriksaanLaboratorium] PRIMARY KEY CLUSTERED ([idPemeriksaanLaboratorium] ASC),
    CONSTRAINT [FK_transaksiPemeriksaanLaboratorium_masterLaboratoriumPemeriksaanItemDetail] FOREIGN KEY ([idDetailItemPemeriksaanLaboratorium]) REFERENCES [dbo].[masterLaboratoriumPemeriksaanItemDetail] ([idDetailItemPemeriksaanLaboratorium]),
    CONSTRAINT [FK_transaksiPemeriksaanLaboratorium_transaksiTindakanPasien] FOREIGN KEY ([idTindakanPasien]) REFERENCES [dbo].[transaksiTindakanPasien] ([idTindakanPasien])
);


GO
CREATE NONCLUSTERED INDEX [IX_transaksiPemeriksaanLaboratorium_idTindakanPasien]
    ON [dbo].[transaksiPemeriksaanLaboratorium]([idTindakanPasien] ASC);

