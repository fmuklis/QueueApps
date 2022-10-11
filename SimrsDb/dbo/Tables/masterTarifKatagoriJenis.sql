CREATE TABLE [dbo].[masterTarifKatagoriJenis] (
    [idMasterKatagoriJenis]   INT           NOT NULL,
    [namaMasterKatagoriJenis] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterTarifKatagoriJenis] PRIMARY KEY CLUSTERED ([idMasterKatagoriJenis] ASC)
);

