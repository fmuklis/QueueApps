CREATE TABLE [dbo].[farmasiMasterDistrobutor] (
    [idDistrobutor]   INT           IDENTITY (1, 1) NOT NULL,
    [namaDistroButor] NVARCHAR (50) NULL,
    [alamat]          NVARCHAR (50) NULL,
    [telepon]         NVARCHAR (50) NULL,
    CONSTRAINT [PK_farmasiMasterDistrobutor] PRIMARY KEY CLUSTERED ([idDistrobutor] ASC)
);

