CREATE TABLE [dbo].[masterMenu] (
    [idMenu]       INT           NOT NULL,
    [namaMenu]     NVARCHAR (50) NOT NULL,
    [namaIconMenu] NVARCHAR (25) NULL,
    CONSTRAINT [PK_masterMenu] PRIMARY KEY CLUSTERED ([idMenu] ASC),
    CONSTRAINT [FK_masterMenuSubGroupMember_masterMenu] FOREIGN KEY ([idMenu]) REFERENCES [dbo].[masterMenu] ([idMenu])
);

