CREATE TABLE [dbo].[masterUserGroup] (
    [idGroupUser]   INT           IDENTITY (1, 1) NOT NULL,
    [namaGroupUser] NVARCHAR (50) NOT NULL,
    [idRumahSakit]  INT           NOT NULL,
    CONSTRAINT [PK_masterUserGroup] PRIMARY KEY CLUSTERED ([idGroupUser] ASC),
    CONSTRAINT [FK_masterUserGroup_masterRumahSakit] FOREIGN KEY ([idRumahSakit]) REFERENCES [dbo].[masterRumahSakit] ([idRumahSakit]) ON UPDATE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_masterUserGroup]
    ON [dbo].[masterUserGroup]([namaGroupUser] ASC);

