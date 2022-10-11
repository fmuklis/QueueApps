CREATE TABLE [dbo].[masterProvinsi] (
    [idProvinsi]   INT           IDENTITY (1, 1) NOT NULL,
    [namaProvinsi] NVARCHAR (50) NOT NULL,
    [idNegara]     INT           NOT NULL,
    [flagDefault]  BIT           CONSTRAINT [DF_masterProvinsi_flagDefault] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_masterProvinsiPasien] PRIMARY KEY CLUSTERED ([idProvinsi] ASC),
    CONSTRAINT [FK_masterProvinsi_masterNegara] FOREIGN KEY ([idNegara]) REFERENCES [dbo].[masterNegara] ([idNegara]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_masterProvinsiPasien]
    ON [dbo].[masterProvinsi]([namaProvinsi] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_masterProvinsiPasien_idNegara]
    ON [dbo].[masterProvinsi]([idNegara] ASC);

