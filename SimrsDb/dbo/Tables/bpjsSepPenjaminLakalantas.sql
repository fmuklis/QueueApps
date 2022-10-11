CREATE TABLE [dbo].[bpjsSepPenjaminLakalantas] (
    [idSepPenjaminLakalantas] BIGINT  IDENTITY (1, 1) NOT NULL,
    [idSep]                   BIGINT  NOT NULL,
    [kodePenjamin]            TINYINT NOT NULL,
    CONSTRAINT [PK_bpjsSepPenjaminLakalantas] PRIMARY KEY CLUSTERED ([idSepPenjaminLakalantas] ASC),
    CONSTRAINT [FK_bpjsSepPenjaminLakalantas_bpjsMasterPenjaminLakalantas] FOREIGN KEY ([kodePenjamin]) REFERENCES [dbo].[bpjsMasterPenjaminLakalantas] ([kodePenjamin]),
    CONSTRAINT [FK_bpjsSepPenjaminLakalantas_bpjsSep] FOREIGN KEY ([idSep]) REFERENCES [dbo].[bpjsSep] ([idSep])
);

