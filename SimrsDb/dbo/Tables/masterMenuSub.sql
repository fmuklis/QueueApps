CREATE TABLE [dbo].[masterMenuSub] (
    [idSubMenu]       INT            NOT NULL,
    [idMenu]          INT            NOT NULL,
    [namaSubMenu]     NVARCHAR (100) NOT NULL,
    [URL]             NVARCHAR (225) NOT NULL,
    [urutan]          INT            NULL,
    [namaIconSubMenu] NVARCHAR (25)  NULL,
    CONSTRAINT [PK_masterMenuSub] PRIMARY KEY CLUSTERED ([idSubMenu] ASC),
    CONSTRAINT [FK_masterMenuSub_masterMenu] FOREIGN KEY ([idMenu]) REFERENCES [dbo].[masterMenu] ([idMenu]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_masterMenuSub_2]
    ON [dbo].[masterMenuSub]([namaSubMenu] ASC, [idMenu] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_masterMenuSub_1]
    ON [dbo].[masterMenuSub]([idSubMenu] ASC);

