CREATE TABLE [dbo].[masterStatusOrderRawatInap] (
    [idStatusOrderRawatInap] TINYINT      NOT NULL,
    [statusOrderRawatInap]   VARCHAR (50) NOT NULL,
    [caption]                VARCHAR (50) NULL,
    CONSTRAINT [PK_masterOrderRawatInap] PRIMARY KEY CLUSTERED ([idStatusOrderRawatInap] ASC),
    CONSTRAINT [FK_masterOrderRawatInap_masterOrderRawatInap] FOREIGN KEY ([idStatusOrderRawatInap]) REFERENCES [dbo].[masterStatusOrderRawatInap] ([idStatusOrderRawatInap])
);

