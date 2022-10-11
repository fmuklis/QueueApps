CREATE TABLE [dbo].[bpjsMasterKecamatan] (
    [kodeKecamatan] VARCHAR (50) NOT NULL,
    [kodeKabupaten] VARCHAR (50) NOT NULL,
    [kecamatan]     VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_bpjsMasterKecamatan] PRIMARY KEY CLUSTERED ([kodeKecamatan] ASC),
    CONSTRAINT [FK_bpjsMasterKecamatan_bpjsMasterkabupaten] FOREIGN KEY ([kodeKabupaten]) REFERENCES [dbo].[bpjsMasterkabupaten] ([kodeKabupaten])
);

