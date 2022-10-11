CREATE TABLE [dbo].[masterStatusKonsul] (
    [idStatusKonsul] TINYINT      IDENTITY (1, 1) NOT NULL,
    [statusKonsul]   VARCHAR (50) NULL,
    [caption]        VARCHAR (50) NULL,
    CONSTRAINT [PK_masterStatusKonsul] PRIMARY KEY CLUSTERED ([idStatusKonsul] ASC)
);

