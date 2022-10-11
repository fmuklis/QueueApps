CREATE TABLE [dbo].[masterStatusBayar] (
    [idStatusBayar] TINYINT      NOT NULL,
    [statusBayar]   VARCHAR (50) NOT NULL,
    [caption]       VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterStatusBayar_1] PRIMARY KEY CLUSTERED ([idStatusBayar] ASC)
);

