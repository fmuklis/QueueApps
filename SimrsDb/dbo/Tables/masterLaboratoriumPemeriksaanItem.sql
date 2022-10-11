CREATE TABLE [dbo].[masterLaboratoriumPemeriksaanItem] (
    [idItemPemeriksaanLaboratorium] INT          IDENTITY (1, 1) NOT NULL,
    [idPemeriksaanLaboratorium]     INT          NOT NULL,
    [itemPemeriksaan]               VARCHAR (50) NOT NULL,
    [multiItem]                     BIT          CONSTRAINT [DF_masterLaboratoriumPemeriksaanItem_tampil] DEFAULT ((0)) NOT NULL,
    [nomorUrut]                     TINYINT      NOT NULL,
    [aktif]                         BIT          CONSTRAINT [DF_masterLaboratoriumPemeriksaanItem_aktif] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_masterLaboratoriumPemeriksaanItem] PRIMARY KEY CLUSTERED ([idItemPemeriksaanLaboratorium] ASC),
    CONSTRAINT [FK_masterLaboratoriumPemeriksaanItem_masterLaboratoriumPemeriksaan] FOREIGN KEY ([idPemeriksaanLaboratorium]) REFERENCES [dbo].[masterLaboratoriumPemeriksaan] ([idPemeriksaanLaboratorium]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_masterLaboratoriumPemeriksaanItem_idPemeriksaanLaboratorium]
    ON [dbo].[masterLaboratoriumPemeriksaanItem]([idPemeriksaanLaboratorium] ASC);

