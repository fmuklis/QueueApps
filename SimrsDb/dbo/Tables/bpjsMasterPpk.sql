CREATE TABLE [dbo].[bpjsMasterPpk] (
    [kodePpkRujukan] VARCHAR (50) NOT NULL,
    [ppkRujukan]     VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_bpjsMasterPpk] PRIMARY KEY CLUSTERED ([kodePpkRujukan] ASC)
);

