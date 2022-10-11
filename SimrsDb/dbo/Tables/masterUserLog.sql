CREATE TABLE [dbo].[masterUserLog] (
    [idUserLog]  INT            IDENTITY (1, 1) NOT NULL,
    [idUser]     INT            NOT NULL,
    [tanggalLog] DATETIME       NOT NULL,
    [keterangan] NVARCHAR (MAX) NULL,
    [IP]         NVARCHAR (19)  NOT NULL,
    CONSTRAINT [PK_masterUserLog] PRIMARY KEY CLUSTERED ([idUserLog] ASC),
    CONSTRAINT [FK_masterMasterLog_masterUser] FOREIGN KEY ([idUser]) REFERENCES [dbo].[masterUser] ([idUser]) ON DELETE CASCADE ON UPDATE CASCADE
);

