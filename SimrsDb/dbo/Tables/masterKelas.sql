CREATE TABLE [dbo].[masterKelas] (
    [idKelas]       INT          NOT NULL,
    [kodeKelas]     VARCHAR (10) CONSTRAINT [DF_masterKelas_kodeKelas] DEFAULT ((0)) NOT NULL,
    [kodeKelasBPJS] TINYINT      CONSTRAINT [DF_masterKelas_kodeKelasBPJS] DEFAULT ((0)) NOT NULL,
    [namaKelas]     VARCHAR (50) NOT NULL,
    [level]         INT          NULL,
    [penjamin]      BIT          CONSTRAINT [DF_masterKelas_penjamin] DEFAULT ((0)) NOT NULL,
    [pelayanan]     BIT          CONSTRAINT [DF_masterKelas_pelayanan] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_masterKelas] PRIMARY KEY CLUSTERED ([idKelas] ASC)
);

