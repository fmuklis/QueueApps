CREATE TABLE [dbo].[farmasiOrderStatus] (
    [idStatusOrder]   INT           IDENTITY (1, 1) NOT NULL,
    [namaStatusOrder] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_farmasiOrderStatus] PRIMARY KEY CLUSTERED ([idStatusOrder] ASC)
);

