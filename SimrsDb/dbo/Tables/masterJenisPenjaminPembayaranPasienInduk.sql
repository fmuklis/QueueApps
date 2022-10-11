CREATE TABLE [dbo].[masterJenisPenjaminPembayaranPasienInduk] (
    [idJenisPenjaminInduk]   INT           IDENTITY (1, 1) NOT NULL,
    [namaJenisPenjaminInduk] NVARCHAR (50) NOT NULL,
    [flagKenaTarifDiagnosa]  BIT           NOT NULL,
    CONSTRAINT [PK_masterJenisPenjaminPembayaranPasienInduk] PRIMARY KEY CLUSTERED ([idJenisPenjaminInduk] ASC)
);

