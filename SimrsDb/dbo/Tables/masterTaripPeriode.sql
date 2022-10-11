CREATE TABLE [dbo].[masterTaripPeriode] (
    [idPeriodeTarip]  INT            IDENTITY (1, 1) NOT NULL,
    [tglMulaiBerlaku] DATE           NULL,
    [nomorDokumen]    NVARCHAR (50)  NULL,
    [keterangan]      NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_masterTaripPeriode] PRIMARY KEY CLUSTERED ([idPeriodeTarip] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_masterTaripPeriode_1]
    ON [dbo].[masterTaripPeriode]([tglMulaiBerlaku] ASC);

