CREATE TABLE [dbo].[masterJenisPenjaminPembayaranPasien] (
    [idJenisPenjaminPembayaranPasien]   INT           IDENTITY (1, 1) NOT NULL,
    [idJenisPenjaminInduk]              INT           NOT NULL,
    [namaJenisPenjaminPembayaranPasien] NVARCHAR (50) NOT NULL,
    [flagKenakelas]                     BIT           NOT NULL,
    [payPlanId]                         TINYINT       NULL,
    [payPlanCode]                       VARCHAR (50)  NULL,
    CONSTRAINT [PK_masterJenisPenjaminPembayaranPasien] PRIMARY KEY CLUSTERED ([idJenisPenjaminPembayaranPasien] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_masterJenisPenjaminPembayaranPasien]
    ON [dbo].[masterJenisPenjaminPembayaranPasien]([namaJenisPenjaminPembayaranPasien] ASC);

