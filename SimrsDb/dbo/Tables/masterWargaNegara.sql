CREATE TABLE [dbo].[masterWargaNegara] (
    [idWargaNegara]   TINYINT       IDENTITY (1, 1) NOT NULL,
    [namaWargaNegara] NVARCHAR (50) NOT NULL,
    [flagDefault]     BIT           CONSTRAINT [DF_masterWargaNegara_flagDefault] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_masterWargaNegaraPasien] PRIMARY KEY CLUSTERED ([idWargaNegara] ASC)
);

