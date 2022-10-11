CREATE TABLE [dbo].[masterJenisRequestRawatInap] (
    [idJenisRequest] INT           NOT NULL,
    [namaRequest]    NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterJenisRequest] PRIMARY KEY CLUSTERED ([idJenisRequest] ASC)
);

