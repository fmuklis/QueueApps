CREATE TABLE [dbo].[consMetodeBayar] (
    [idMetodeBayar] TINYINT      IDENTITY (1, 1) NOT NULL,
    [metodeBayar]   VARCHAR (50) NOT NULL,
    [piutang]       BIT          CONSTRAINT [DF_consMetodeBayar_piutang] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_consMetodeBayar] PRIMARY KEY CLUSTERED ([idMetodeBayar] ASC)
);

