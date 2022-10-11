CREATE TABLE [dbo].[masterLaboratoriumPemeriksaan] (
    [idPemeriksaanLaboratorium]      INT     IDENTITY (1, 1) NOT NULL,
    [idJenisPemeriksaanLaboratorium] TINYINT NOT NULL,
    [idMasterTarifHeader]            INT     NOT NULL,
    [nomorUrut]                      TINYINT NOT NULL,
    CONSTRAINT [PK_masterLaboratoriumPemeriksaan] PRIMARY KEY CLUSTERED ([idPemeriksaanLaboratorium] ASC),
    CONSTRAINT [FK_masterLaboratoriumPemeriksaan_masterLaboratoriumPemeriksaanJenis] FOREIGN KEY ([idJenisPemeriksaanLaboratorium]) REFERENCES [dbo].[masterLaboratoriumPemeriksaanJenis] ([idJenisPemeriksaanLaboratorium]) ON DELETE CASCADE,
    CONSTRAINT [FK_masterLaboratoriumPemeriksaan_masterTarifHeader] FOREIGN KEY ([idMasterTarifHeader]) REFERENCES [dbo].[masterTarifHeader] ([idMasterTarifHeader]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_masterLaboratoriumPemeriksaan_idMasterTarifHeader]
    ON [dbo].[masterLaboratoriumPemeriksaan]([idMasterTarifHeader] ASC);

