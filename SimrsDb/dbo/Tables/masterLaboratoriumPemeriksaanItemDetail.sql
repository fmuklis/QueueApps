CREATE TABLE [dbo].[masterLaboratoriumPemeriksaanItemDetail] (
    [idDetailItemPemeriksaanLaboratorium] INT            IDENTITY (1, 1) NOT NULL,
    [idItemPemeriksaanLaboratorium]       INT            NOT NULL,
    [detailItemPemeriksaan]               VARCHAR (50)   NOT NULL,
    [satuan]                              NVARCHAR (50)  NOT NULL,
    [nilaiRujukan]                        NVARCHAR (500) NOT NULL,
    [nomorUrut]                           TINYINT        NOT NULL,
    [aktif]                               BIT            CONSTRAINT [DF_masterLaboratoriumPemeriksaanItemDetail_aktif] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_masterLaboratoriumPemeriksaanItemDetail] PRIMARY KEY CLUSTERED ([idDetailItemPemeriksaanLaboratorium] ASC),
    CONSTRAINT [FK_masterLaboratoriumPemeriksaanItemDetail_masterLaboratoriumPemeriksaanItem] FOREIGN KEY ([idItemPemeriksaanLaboratorium]) REFERENCES [dbo].[masterLaboratoriumPemeriksaanItem] ([idItemPemeriksaanLaboratorium]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_masterLaboratoriumPemeriksaanItemDetail_idItemPemeriksaanLaboratorium]
    ON [dbo].[masterLaboratoriumPemeriksaanItemDetail]([idItemPemeriksaanLaboratorium] ASC);

