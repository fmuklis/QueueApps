CREATE TABLE [dbo].[masterUser] (
    [idUser]              INT           IDENTITY (1, 1) NOT NULL,
    [userName]            NVARCHAR (25) NOT NULL,
    [namaLengkap]         NVARCHAR (50) NOT NULL,
    [noKaryawan]          NVARCHAR (50) NOT NULL,
    [idGroupUser]         INT           NOT NULL,
    [userPassword]        NVARCHAR (32) NOT NULL,
    [noHp]                NVARCHAR (50) NULL,
    [idRuangan]           INT           NOT NULL,
    [idStatusPendaftaran] INT           NULL,
    [nik]                 VARCHAR (50)  NULL,
    CONSTRAINT [PK_user] PRIMARY KEY CLUSTERED ([idUser] ASC),
    CONSTRAINT [FK_masterUser_masterRuangan] FOREIGN KEY ([idRuangan]) REFERENCES [dbo].[masterRuangan] ([idRuangan]),
    CONSTRAINT [FK_masterUser_masterUserGroup] FOREIGN KEY ([idGroupUser]) REFERENCES [dbo].[masterUserGroup] ([idGroupUser]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_masterUser]
    ON [dbo].[masterUser]([userName] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_masterUser_1]
    ON [dbo].[masterUser]([idUser] ASC);

