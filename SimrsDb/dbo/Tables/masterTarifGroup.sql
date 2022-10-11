CREATE TABLE [dbo].[masterTarifGroup] (
    [idMasterTarifGroup] SMALLINT      NOT NULL,
    [namaTarifGroup]     NVARCHAR (50) NOT NULL,
    [orderNumber]        TINYINT       NULL,
    CONSTRAINT [PK_masterTarifGroup] PRIMARY KEY CLUSTERED ([idMasterTarifGroup] ASC)
);

