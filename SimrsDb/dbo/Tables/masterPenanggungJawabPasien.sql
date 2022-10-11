CREATE TABLE [dbo].[masterPenanggungJawabPasien] (
    [idPenanggungJawabPasien]             INT            IDENTITY (1, 1) NOT NULL,
    [idHubunganKeluarga]                  INT            NOT NULL,
    [namaPenanggungJawabPasien]           NVARCHAR (50)  NOT NULL,
    [alamatPenanggungJawabPasien]         NVARCHAR (225) NOT NULL,
    [idDokumenIdentitas]                  INT            NULL,
    [noIdentitasPenanggungJawabPasien]    NVARCHAR (20)  NULL,
    [idJenisKelaminPenanggungJawabPasien] TINYINT        NULL,
    [idPekerjaanPenanggungJawabPasien]    TINYINT        NULL,
    [noHpPenanggungJawabPasien1]          NVARCHAR (50)  NOT NULL,
    [noHpPenanggungJawabPasien2]          NVARCHAR (50)  NULL,
    [namaPerusahaan]                      NVARCHAR (50)  NULL,
    [alamatPerusahaan]                    NVARCHAR (50)  NULL,
    [noTeleponPerusahaan]                 NVARCHAR (50)  NULL,
    [namaPengantarPasien]                 NVARCHAR (50)  NULL,
    [alamatPengantarPasien]               NVARCHAR (220) NULL,
    [noTeleponPengantarPasien]            NVARCHAR (50)  NULL,
    CONSTRAINT [PK_masterPenanggungJawabPasien] PRIMARY KEY CLUSTERED ([idPenanggungJawabPasien] ASC),
    CONSTRAINT [FK_masterPenanggungJawabPasien_masterHubunganKeluarga] FOREIGN KEY ([idHubunganKeluarga]) REFERENCES [dbo].[masterHubunganKeluarga] ([idHubunganKeluarga]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_masterPenanggungJawabPasien_masterJenisKelamin] FOREIGN KEY ([idJenisKelaminPenanggungJawabPasien]) REFERENCES [dbo].[masterJenisKelamin] ([idJenisKelamin]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_masterPenanggungJawabPasien_masterPekerjaan] FOREIGN KEY ([idPekerjaanPenanggungJawabPasien]) REFERENCES [dbo].[masterPekerjaan] ([idPekerjaan]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_masterPenanggungJawabPasien]
    ON [dbo].[masterPenanggungJawabPasien]([namaPenanggungJawabPasien] ASC);

