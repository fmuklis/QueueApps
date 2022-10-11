CREATE TABLE [dbo].[farmasiResepKemasan] (
    [idKemasan]   INT            IDENTITY (1, 1) NOT NULL,
    [namaKemasan] NVARCHAR (250) NOT NULL,
    CONSTRAINT [PK_farmasiResepKemasan] PRIMARY KEY CLUSTERED ([idKemasan] ASC)
);

