CREATE TABLE [dbo].[masterKonfigurasi] (
    [idKonfigurasi]                                  INT             IDENTITY (1, 1) NOT NULL,
    [persentaseHargaJualFarmasi]                     DECIMAL (18, 2) NOT NULL,
    [persentaseJasaDokterKebidananRawatJalanBPJS]    DECIMAL (18, 2) NULL,
    [persentaseJasaDokterNonKebidananRawatJalanBPJS] DECIMAL (18, 2) NULL,
    [jumlahBayarVisitDokterUmumRawatJalanBPJS]       MONEY           NULL,
    [persentasePPN]                                  DECIMAL (18, 2) NULL,
    [flagPPNJual]                                    BIT             NULL,
    [PPNJual]                                        DECIMAL (18, 2) NULL,
    [biayaKartuJaga]                                 MONEY           NULL,
    [idPenanggungJawabLaboratorium]                  INT             NULL,
    [kodeTarifINACBG]                                VARCHAR (50)    NULL,
    [bhpDitagihkan]                                  BIT             CONSTRAINT [DF_masterKonfigurasi_bhpDitagihkan] DEFAULT ((1)) NULL,
    [alamatLengkap]                                  VARCHAR (255)   NULL,
    [kota]                                           VARCHAR (100)   NULL,
    CONSTRAINT [PK_masterKonfigurasi] PRIMARY KEY CLUSTERED ([idKonfigurasi] ASC),
    CONSTRAINT [FK_masterKonfigurasi_masterOperator] FOREIGN KEY ([idPenanggungJawabLaboratorium]) REFERENCES [dbo].[masterOperator] ([idOperator])
);

