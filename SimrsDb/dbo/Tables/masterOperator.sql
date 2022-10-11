CREATE TABLE [dbo].[masterOperator] (
    [idOperator]      INT           IDENTITY (1, 1) NOT NULL,
    [NamaOperator]    NVARCHAR (50) NOT NULL,
    [idJenisOperator] INT           NOT NULL,
    [aktif]           BIT           CONSTRAINT [DF_masterOperator_aktif] DEFAULT ((1)) NULL,
    [hp]              VARCHAR (15)  NULL,
    CONSTRAINT [PK_masterOperator] PRIMARY KEY CLUSTERED ([idOperator] ASC)
);

