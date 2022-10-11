CREATE TABLE [dbo].[masterLaboratoriumPemeriksaanGolongan] (
    [idGolonganPemeriksaanLaboratorium] TINYINT      IDENTITY (1, 1) NOT NULL,
    [golonganPemeriksaan]               VARCHAR (50) NOT NULL,
    [nomorUrut]                         TINYINT      NOT NULL,
    CONSTRAINT [PK_masterLaboratoriumPemeriksaanGolongan] PRIMARY KEY CLUSTERED ([idGolonganPemeriksaanLaboratorium] ASC)
);

