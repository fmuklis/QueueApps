CREATE TABLE [dbo].[masterDiagnosaJenis] (
    [idJenisDiagnosa]   BIT           NOT NULL,
    [namaJenisDiagnosa] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterDiagnosaJenis] PRIMARY KEY CLUSTERED ([idJenisDiagnosa] ASC)
);

