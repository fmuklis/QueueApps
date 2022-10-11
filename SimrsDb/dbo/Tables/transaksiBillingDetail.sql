CREATE TABLE [dbo].[transaksiBillingDetail] (
    [idBillingDeatil] INT             IDENTITY (1, 1) NOT NULL,
    [idBilling]       INT             NOT NULL,
    [idMasterTarif]   INT             NOT NULL,
    [Nilai]           MONEY           NOT NULL,
    [jumlah]          DECIMAL (18, 2) NOT NULL,
    CONSTRAINT [PK_transaksiBillingDetail] PRIMARY KEY CLUSTERED ([idBillingDeatil] ASC)
);

