CREATE TABLE [dbo].[masterMenuSubGroupMember] (
    [idSubmenuGroupMember] INT     NOT NULL,
    [idGroupUser]          INT     NOT NULL,
    [idMenu]               INT     NULL,
    [idSubMenu]            INT     NOT NULL,
    [menuOrder]            TINYINT NULL,
    [subMenuOrder]         TINYINT NULL,
    CONSTRAINT [PK_masterMenuSubGroupMember] PRIMARY KEY CLUSTERED ([idSubmenuGroupMember] ASC),
    CONSTRAINT [FK_masterMenuSubGroupMember_masterMenuSub] FOREIGN KEY ([idSubMenu]) REFERENCES [dbo].[masterMenuSub] ([idSubMenu]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_masterMenuSubGroupMember_masterUserGroup] FOREIGN KEY ([idGroupUser]) REFERENCES [dbo].[masterUserGroup] ([idGroupUser]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_masterMenuSubGroupMember]
    ON [dbo].[masterMenuSubGroupMember]([idGroupUser] ASC, [idSubMenu] ASC);

