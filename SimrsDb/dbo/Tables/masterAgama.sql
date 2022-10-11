CREATE TABLE [dbo].[masterAgama] (
    [idAgama]   TINYINT       IDENTITY (1, 1) NOT NULL,
    [namaAgama] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterAgamaPasien] PRIMARY KEY CLUSTERED ([idAgama] ASC)
);

