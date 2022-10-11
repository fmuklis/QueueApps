CREATE TABLE [dbo].[bpjsMasterkabupaten] (
    [kodeKabupaten] VARCHAR (50) NOT NULL,
    [kodePropinsi]  VARCHAR (50) NOT NULL,
    [kabupaten]     VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_bpjsMasterkabupaten] PRIMARY KEY CLUSTERED ([kodeKabupaten] ASC),
    CONSTRAINT [FK_bpjsMasterkabupaten_bpjsMasterPropinsi] FOREIGN KEY ([kodePropinsi]) REFERENCES [dbo].[bpjsMasterPropinsi] ([kodePropinsi])
);

