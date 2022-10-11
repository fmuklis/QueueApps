CREATE TABLE [dbo].[apiBridgeAccount] (
    [idApi]       SMALLINT      NOT NULL,
    [description] VARCHAR (50)  NOT NULL,
    [protocol]    VARCHAR (50)  NULL,
    [baseUrl]     VARCHAR (50)  NULL,
    [token]       VARCHAR (250) NULL,
    [consId]      VARCHAR (50)  NULL,
    [secret]      VARCHAR (50)  NULL,
    [ppk]         VARCHAR (50)  NULL,
    [ppkNama]     VARCHAR (50)  NULL,
    [isActive]    BIT           NULL,
    CONSTRAINT [PK_api_accountt] PRIMARY KEY CLUSTERED ([idApi] ASC)
);

