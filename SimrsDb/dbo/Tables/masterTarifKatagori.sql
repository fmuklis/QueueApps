CREATE TABLE [dbo].[masterTarifKatagori] (
    [idMasterKatagoriTarip]       INT           IDENTITY (1, 1) NOT NULL,
    [namaMasterKatagoriTarif]     NVARCHAR (50) NOT NULL,
    [namaMasterKatagoriInProgram] NVARCHAR (50) NOT NULL,
    [idMasterKatagoriJenis]       INT           NOT NULL,
    CONSTRAINT [PK_masterTarifKatagori] PRIMARY KEY CLUSTERED ([idMasterKatagoriTarip] ASC),
    CONSTRAINT [FK_masterTarifKatagori_masterTarifKatagoriJenis] FOREIGN KEY ([idMasterKatagoriJenis]) REFERENCES [dbo].[masterTarifKatagoriJenis] ([idMasterKatagoriJenis])
);

