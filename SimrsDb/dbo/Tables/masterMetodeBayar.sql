CREATE TABLE [dbo].[masterMetodeBayar] (
    [idMetodeBayar]   TINYINT      IDENTITY (1, 1) NOT NULL,
    [namaMetodeBayar] VARCHAR (50) NOT NULL,
    [piutang]         BIT          CONSTRAINT [DF_masterMetodeBayar_piutang] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_masterMetodeBayar] PRIMARY KEY CLUSTERED ([idMetodeBayar] ASC)
);

