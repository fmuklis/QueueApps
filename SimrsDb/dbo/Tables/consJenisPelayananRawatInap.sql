CREATE TABLE [dbo].[consJenisPelayananRawatInap] (
    [idJenisPelayananRawatInap] TINYINT      NOT NULL,
    [jenisPelayananRawatInap]   VARCHAR (50) NOT NULL,
    [pelayananKhusus]           BIT          CONSTRAINT [DF_consJenisPelayananRawatInap_pelayananKhusus] DEFAULT ((0)) NOT NULL,
    [perinatologi]              BIT          CONSTRAINT [DF_consJenisPelayananRawatInap_perinatologi] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_consJenisPelayananRawatInap] PRIMARY KEY CLUSTERED ([idJenisPelayananRawatInap] ASC)
);

