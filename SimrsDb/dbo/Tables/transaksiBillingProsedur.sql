CREATE TABLE [dbo].[transaksiBillingProsedur] (
    [idBillingProsedur] BIGINT IDENTITY (1, 1) NOT NULL,
    [idBilling]         BIGINT NOT NULL,
    [idMasterProsedur]  INT    NOT NULL,
    CONSTRAINT [PK_transaksiBillingProsedur] PRIMARY KEY CLUSTERED ([idBillingProsedur] ASC),
    CONSTRAINT [FK_transaksiBillingProsedur_masterICDProsedur] FOREIGN KEY ([idMasterProsedur]) REFERENCES [dbo].[masterICDProsedur] ([idMasterProsedur]),
    CONSTRAINT [FK_transaksiBillingProsedur_transaksiBillingHeader] FOREIGN KEY ([idBilling]) REFERENCES [dbo].[transaksiBillingHeader] ([idBilling])
);

