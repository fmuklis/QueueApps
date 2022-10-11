CREATE TABLE [dbo].[masterOperatorJenis] (
    [idJenisOperator]       INT           IDENTITY (1, 1) NOT NULL,
    [namaJenisOperator]     NVARCHAR (50) NOT NULL,
    [idMasterKatagoriTarip] INT           NOT NULL,
    [jenisSpesialisasi]     NVARCHAR (50) NULL,
    CONSTRAINT [PK_masterOperatorJenis] PRIMARY KEY CLUSTERED ([idJenisOperator] ASC),
    CONSTRAINT [FK_masterOperatorJenis_masterTarifKatagori] FOREIGN KEY ([idMasterKatagoriTarip]) REFERENCES [dbo].[masterTarifKatagori] ([idMasterKatagoriTarip]) ON DELETE CASCADE ON UPDATE CASCADE
);

