CREATE TABLE [dbo].[masterPelayanan] (
    [idMasterPelayanan]   INT            IDENTITY (1, 1) NOT NULL,
    [namaMasterPelayanan] NVARCHAR (225) NOT NULL,
    CONSTRAINT [PK_masterPelayanan] PRIMARY KEY CLUSTERED ([idMasterPelayanan] ASC)
);

