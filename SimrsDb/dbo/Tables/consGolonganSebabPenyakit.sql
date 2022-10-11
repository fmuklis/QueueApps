CREATE TABLE [dbo].[consGolonganSebabPenyakit] (
    [idGolonganSebabPenyakit] INT           NOT NULL,
    [nomorDTD]                VARCHAR (10)  NOT NULL,
    [nomorDaftarTerperinci]   VARCHAR (250) NOT NULL,
    [golonganSebabPenyakit]   VARCHAR (250) NOT NULL,
    [penyebab]                BIT           CONSTRAINT [DF_consGolonganSebabPenyakit_penyebab] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_masterGolonganSebabPenyakit] PRIMARY KEY CLUSTERED ([idGolonganSebabPenyakit] ASC)
);

