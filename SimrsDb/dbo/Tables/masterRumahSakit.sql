CREATE TABLE [dbo].[masterRumahSakit] (
    [idRumahSakit]         INT            NOT NULL,
    [kodeRS]               NVARCHAR (20)  NOT NULL,
    [namaRumahSakit]       NVARCHAR (50)  NOT NULL,
    [namaPendekRumahSakit] NVARCHAR (50)  NULL,
    [headerSurat1]         NVARCHAR (225) NULL,
    [alamat]               NVARCHAR (200) NOT NULL,
    [kodePos]              NVARCHAR (50)  NOT NULL,
    [telp]                 NVARCHAR (50)  NOT NULL,
    [email]                NVARCHAR (50)  NOT NULL,
    [namaDirektur]         NVARCHAR (50)  NOT NULL,
    [namaSekretaris]       NVARCHAR (50)  NOT NULL,
    [kota]                 NVARCHAR (50)  NOT NULL,
    [kabupaten]            NVARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_masterRumahSakit] PRIMARY KEY CLUSTERED ([idRumahSakit] ASC)
);

