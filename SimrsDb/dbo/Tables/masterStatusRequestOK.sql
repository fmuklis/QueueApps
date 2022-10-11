CREATE TABLE [dbo].[masterStatusRequestOK] (
    [idStatusOrderOK] TINYINT      NOT NULL,
    [statusOperasi]   VARCHAR (50) NOT NULL,
    [caption]         VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterStatusRequestOK] PRIMARY KEY CLUSTERED ([idStatusOrderOK] ASC)
);

