CREATE TABLE [dbo].[masterPenyakit] (
    [idPenyakit]   INT            IDENTITY (1, 1) NOT NULL,
    [kodeICD]      NVARCHAR (50)  NULL,
    [namaPenyakit] NVARCHAR (225) NOT NULL,
    [keterangan]   NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_masterPenyakit] PRIMARY KEY CLUSTERED ([idPenyakit] ASC)
);

