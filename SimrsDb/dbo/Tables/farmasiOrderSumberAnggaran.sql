CREATE TABLE [dbo].[farmasiOrderSumberAnggaran] (
    [idOrderSumberAnggaran] SMALLINT     IDENTITY (1, 1) NOT NULL,
    [orderSumberAnggaran]   VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_farmasiOrderSumberAnggaran] PRIMARY KEY CLUSTERED ([idOrderSumberAnggaran] ASC)
);

