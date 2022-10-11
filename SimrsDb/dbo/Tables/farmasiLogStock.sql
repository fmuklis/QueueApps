CREATE TABLE [dbo].[farmasiLogStock] (
    [dateCreated]  SMALLDATETIME  CONSTRAINT [DF_farmasiLogStock_dateCreated] DEFAULT (getdate()) NOT NULL,
    [idObatDetail] BIGINT         NOT NULL,
    [action]       VARCHAR (50)   NOT NULL,
    [query]        NVARCHAR (MAX) NULL,
    [logData]      NVARCHAR (MAX) NOT NULL
);

