CREATE TABLE [dbo].[masterStatusOrder] (
    [idStatusOrder]   INT          NOT NULL,
    [namaStatusOrder] VARCHAR (50) NULL,
    [caption]         VARCHAR (50) NULL,
    CONSTRAINT [PK_masterStatusOrder] PRIMARY KEY CLUSTERED ([idStatusOrder] ASC)
);

