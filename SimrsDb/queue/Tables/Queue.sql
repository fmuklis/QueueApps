CREATE TABLE [queue].[Queue] (
    [QueueId]       BIGINT   IDENTITY (1, 1) NOT NULL,
    [ServiceTypeId] TINYINT  NOT NULL,
    [CounterId]     TINYINT  NULL,
    [DateOfQueue]   DATE     NOT NULL,
    [QueueNumber]   INT      NOT NULL,
    [QueueStatusId] TINYINT  NOT NULL,
    [CreatedAt]     DATETIME NOT NULL DEFAULT getdate(),
    [ModifiedAt]    DATETIME NULL,
    CONSTRAINT [PK_Queue] PRIMARY KEY CLUSTERED ([QueueId] ASC), 
    CONSTRAINT [FK_Queue_ToTable] FOREIGN KEY ([ServiceTypeId]) REFERENCES [queue].[ConstServiceType]([ServiceTypeId]), 
    CONSTRAINT [FK_Queue_ToTable_1] FOREIGN KEY ([QueueStatusId]) REFERENCES [queue].[ConstStatus]([QueueStatusId]) 
);

