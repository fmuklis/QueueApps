CREATE TABLE [dbo].[masterStatusKlaim] (
    [idStatusKlaim] TINYINT      NOT NULL,
    [statusKlaim]   VARCHAR (50) NOT NULL,
    [caption]       VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterStatusKlaim] PRIMARY KEY CLUSTERED ([idStatusKlaim] ASC)
);

