CREATE TABLE [dbo].[masterLaboratoriumPemeriksaanJenis] (
    [idJenisPemeriksaanLaboratorium]    TINYINT      IDENTITY (1, 1) NOT NULL,
    [idGolonganPemeriksaanLaboratorium] TINYINT      NULL,
    [jenisPemeriksaan]                  VARCHAR (50) NOT NULL,
    [nomorUrut]                         TINYINT      NOT NULL,
    CONSTRAINT [PK_masterLaboratoriumPemeriksaanJenis] PRIMARY KEY CLUSTERED ([idJenisPemeriksaanLaboratorium] ASC),
    CONSTRAINT [FK_masterLaboratoriumPemeriksaanJenis_masterLaboratoriumPemeriksaanGolongan] FOREIGN KEY ([idGolonganPemeriksaanLaboratorium]) REFERENCES [dbo].[masterLaboratoriumPemeriksaanGolongan] ([idGolonganPemeriksaanLaboratorium]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_masterLaboratoriumPemeriksaanJenis_idJenisPemeriksaanLaboratorium]
    ON [dbo].[masterLaboratoriumPemeriksaanJenis]([idJenisPemeriksaanLaboratorium] ASC);

