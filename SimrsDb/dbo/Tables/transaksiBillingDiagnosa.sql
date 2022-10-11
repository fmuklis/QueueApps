CREATE TABLE [dbo].[transaksiBillingDiagnosa] (
    [idBillingDiagnosa] BIGINT IDENTITY (1, 1) NOT NULL,
    [idBilling]         BIGINT NOT NULL,
    [idMasterICD]       INT    NOT NULL,
    [primer]            BIT    NOT NULL,
    CONSTRAINT [PK_transaksiBillingDiagnosa] PRIMARY KEY CLUSTERED ([idBillingDiagnosa] ASC),
    CONSTRAINT [FK_transaksiBillingDiagnosa_masterICD] FOREIGN KEY ([idMasterICD]) REFERENCES [dbo].[masterICD] ([idMasterICD]),
    CONSTRAINT [FK_transaksiBillingDiagnosa_transaksiBillingHeader] FOREIGN KEY ([idBilling]) REFERENCES [dbo].[transaksiBillingHeader] ([idBilling])
);

