CREATE TABLE [dbo].[bpjsMasterPenjaminLakalantas] (
    [kodePenjamin]       TINYINT      NOT NULL,
    [penjaminLakalantas] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_bpjsMasterPenjaminLakalantas] PRIMARY KEY CLUSTERED ([kodePenjamin] ASC)
);

