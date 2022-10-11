CREATE TABLE [dbo].[masterPasienLuar] (
    [idPasienLuar]   BIGINT         IDENTITY (1, 1) NOT NULL,
    [nama]           NVARCHAR (250) NOT NULL,
    [idJenisKelamin] TINYINT        NOT NULL,
    [tglLahir]       DATE           NOT NULL,
    [alamat]         NVARCHAR (250) NOT NULL,
    [dokter]         NVARCHAR (250) NOT NULL,
    [tlp]            NVARCHAR (15)  NOT NULL,
    [karyawan]       BIT            CONSTRAINT [DF_masterPasienLuar_karyawan] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_masterPasienLuar] PRIMARY KEY CLUSTERED ([idPasienLuar] ASC),
    CONSTRAINT [FK_masterPasienLuar_masterJenisKelamin] FOREIGN KEY ([idJenisKelamin]) REFERENCES [dbo].[masterJenisKelamin] ([idJenisKelamin])
);

