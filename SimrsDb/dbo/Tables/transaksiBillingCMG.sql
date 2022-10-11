CREATE TABLE [dbo].[transaksiBillingCMG] (
    [idTransaksiBillingCMG] BIGINT       IDENTITY (1, 1) NOT NULL,
    [idBilling]             BIGINT       NOT NULL,
    [idMasterCMG]           INT          NOT NULL,
    [kode]                  VARCHAR (10) NULL,
    [tarif]                 MONEY        NULL,
    CONSTRAINT [PK_transaksiBillingCMG] PRIMARY KEY CLUSTERED ([idTransaksiBillingCMG] ASC),
    CONSTRAINT [FK_transaksiBillingCMG_masterCMG] FOREIGN KEY ([idMasterCMG]) REFERENCES [dbo].[masterCMG] ([idMasterCMG]),
    CONSTRAINT [FK_transaksiBillingCMG_transaksiBillingHeader] FOREIGN KEY ([idBilling]) REFERENCES [dbo].[transaksiBillingHeader] ([idBilling])
);

