CREATE TABLE [dbo].[farmasiPenjualanHeader] (
    [idPenjualanHeader] BIGINT   IDENTITY (1, 1) NOT NULL,
    [idResep]           BIGINT   NULL,
    [idPetugasFarmasi]  INT      NULL,
    [idStatusPenjualan] TINYINT  CONSTRAINT [DF_farmasiPenjualanHeader_idStatusPenjualan] DEFAULT ((1)) NULL,
    [idBilling]         BIGINT   NULL,
    [tglJual]           DATE     CONSTRAINT [DF_farmasiPenjualanHeader_tglJual] DEFAULT (getdate()) NULL,
    [tglEntry]          DATETIME CONSTRAINT [DF_farmasiPenjualanHeader_tglEntry] DEFAULT (getdate()) NOT NULL,
    [idUserEntry]       INT      NOT NULL,
    [flagKaryawan]      BIT      CONSTRAINT [DF_farmasiPenjualanHeader_flagKaryawan] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_farmasiPenjualanHeader] PRIMARY KEY CLUSTERED ([idPenjualanHeader] ASC),
    CONSTRAINT [FK_farmasiPenjualanHeader_farmasiMasterStatusPenjualan] FOREIGN KEY ([idStatusPenjualan]) REFERENCES [dbo].[farmasiMasterStatusPenjualan] ([idStatusPenjualan]),
    CONSTRAINT [FK_farmasiPenjualanHeader_farmasiResep] FOREIGN KEY ([idResep]) REFERENCES [dbo].[farmasiResep] ([idResep]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_farmasiPenjualanHeader_transaksiBillingHeader] FOREIGN KEY ([idBilling]) REFERENCES [dbo].[transaksiBillingHeader] ([idBilling])
);


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER hapusPenjualanHeader
   ON  dbo.farmasiPenjualanHeader
   AFTER DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @idResep int;
	Select @idResep=idResep from deleted;
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	update farmasiResep set idStatusResep=1 where idResep=@idResep;

END