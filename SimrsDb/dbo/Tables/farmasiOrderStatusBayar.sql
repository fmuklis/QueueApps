CREATE TABLE [dbo].[farmasiOrderStatusBayar] (
    [idStatusBayar]   INT           IDENTITY (1, 1) NOT NULL,
    [namaStatusBayar] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterStatusBayar] PRIMARY KEY CLUSTERED ([idStatusBayar] ASC)
);

