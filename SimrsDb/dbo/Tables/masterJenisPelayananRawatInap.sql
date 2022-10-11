CREATE TABLE [dbo].[masterJenisPelayananRawatInap] (
    [idJenisPelayananRawatInap] TINYINT      NOT NULL,
    [jenisPelayananRawatInap]   VARCHAR (50) NOT NULL,
    [pelayananKhusus]           BIT          CONSTRAINT [DF_masterJenisPelayananRawatInap_pelayananKhusus] DEFAULT ((0)) NOT NULL,
    [perinatologi]              BIT          CONSTRAINT [DF_masterJenisPelayananRawatInap_perinatologi] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_masterJenisPelayananRawatInap] PRIMARY KEY CLUSTERED ([idJenisPelayananRawatInap] ASC)
);

