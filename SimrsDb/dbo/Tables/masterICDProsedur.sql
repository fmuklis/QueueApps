CREATE TABLE [dbo].[masterICDProsedur] (
    [idMasterProsedur] INT            IDENTITY (1, 1) NOT NULL,
    [kodeProsedur]     NVARCHAR (50)  NOT NULL,
    [prosedur]         NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_masterICDProsedur] PRIMARY KEY CLUSTERED ([idMasterProsedur] ASC)
);

