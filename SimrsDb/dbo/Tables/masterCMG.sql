CREATE TABLE [dbo].[masterCMG] (
    [idMasterCMG]     INT         IDENTITY (1, 1) NOT NULL,
    [idMasterCMGType] SMALLINT    NOT NULL,
    [kodeCMG]         NCHAR (50)  NOT NULL,
    [description]     NCHAR (250) NOT NULL,
    CONSTRAINT [PK_masterCMG] PRIMARY KEY CLUSTERED ([idMasterCMG] ASC),
    CONSTRAINT [FK_masterCMG_masterCMGType] FOREIGN KEY ([idMasterCMGType]) REFERENCES [dbo].[masterCMGType] ([idMasterCMGType])
);

