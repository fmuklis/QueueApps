CREATE TABLE [dbo].[masterStatusPendaftaranAttachment] (
    [idStatusPendaftaranAttachment] TINYINT      NOT NULL,
    [status]                        VARCHAR (20) NULL,
    [caption]                       VARCHAR (50) NULL,
    CONSTRAINT [PK_masterStatusPendaftaranAttachment] PRIMARY KEY CLUSTERED ([idStatusPendaftaranAttachment] ASC)
);

