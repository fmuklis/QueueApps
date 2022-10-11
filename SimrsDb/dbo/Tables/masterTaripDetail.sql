CREATE TABLE [dbo].[masterTaripDetail] (
    [idMasterTarifDetail]   INT      IDENTITY (1, 1) NOT NULL,
    [idMasterTarip]         INT      NOT NULL,
    [idMasterKatagoriTarip] INT      NOT NULL,
    [tarip]                 MONEY    NOT NULL,
    [status]                BIT      CONSTRAINT [DF_masterTaripDetail_status] DEFAULT ((1)) NULL,
    [tglNonAktif]           DATETIME NULL,
    CONSTRAINT [PK_masterTaripDetail] PRIMARY KEY CLUSTERED ([idMasterTarifDetail] ASC),
    CONSTRAINT [FK_masterTaripDetail_masterTarifKatagori] FOREIGN KEY ([idMasterKatagoriTarip]) REFERENCES [dbo].[masterTarifKatagori] ([idMasterKatagoriTarip]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_masterTaripDetail_masterTarip] FOREIGN KEY ([idMasterTarip]) REFERENCES [dbo].[masterTarip] ([idMasterTarif]) ON DELETE CASCADE ON UPDATE CASCADE
);

