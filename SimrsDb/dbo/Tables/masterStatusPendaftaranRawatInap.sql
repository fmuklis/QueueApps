CREATE TABLE [dbo].[masterStatusPendaftaranRawatInap] (
    [idStatusPendaftaranRawatInap] INT           IDENTITY (1, 1) NOT NULL,
    [statusPendaftaranRawatInap]   NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_masterStatusPendaftaranRawatInap] PRIMARY KEY CLUSTERED ([idStatusPendaftaranRawatInap] ASC)
);

