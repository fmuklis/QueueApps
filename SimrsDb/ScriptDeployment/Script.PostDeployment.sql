/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

/*Seed queue status data
DECLARE @status TABLE
(
	[StatusId] TINYINT NOT NULL, 
    [StatusName] VARCHAR(50) NOT NULL
)

INSERT INTO @status
           (StatusId, StatusName)
     VALUES
           (0, 'Tidak Hadir'),
           (1, 'Belum Dilayani'),
           (2, 'Belum Datang'),
           (3, 'Sedang Dilayani'),
           (5, 'Selesai Dilayani')
      
INSERT INTO [queue].[ConstStatus]
           (QueueStatusId
           ,[StatusName])
     SELECT a.StatusId
           ,a.StatusName
       FROM @status a
            LEFT JOIN [queue].[ConstStatus] b ON a.StatusId = b.StatusId
      WHERE b.StatusId IS NULL;

/*Seed counter data*/
DECLARE @counter TABLE
(
        [CounterId] TINYINT NOT NULL, 
        [CounterName] VARCHAR(50) NOT NULL
)

INSERT INTO @counter
           (CounterId, CounterName)
     VALUES
           (1, 'Loket 1'),
           (2, 'Loket 2'),
           (3, 'Loket 3'),
           (4, 'Loket 4'),
           (5, 'Loket 5')

INSERT INTO [queue].ConstCounter
           ([CounterId]
           ,[CounterName])
     SELECT a.CounterId
           ,a.CounterName
       FROM @counter a
            LEFT JOIN [queue].ConstCounter b ON a.CounterId = b.CounterId
      WHERE b.CounterId IS NULL;

/*Seed queue type data*/
DECLARE @type TABLE
(
	[TypeId] TINYINT NOT NULL, 
    [TypeName] VARCHAR(50) NOT NULL
)

INSERT INTO @type
           (TypeId, TypeName)
     VALUES
           (1, 'BPJS'),
           (2, 'UMUM')

INSERT INTO [queue].ConstType
           ([TypeId]
           ,[TypeName])
     SELECT a.TypeId
           ,a.TypeName
       FROM @type a
            LEFT JOIN [queue].ConstType b ON a.TypeId = b.TypeId
      WHERE b.TypeId IS NULL;

/*Seed service category data*/
DECLARE @serviceCategory TABLE
(
	[ServiceCategoryId] TINYINT NOT NULL, 
    [ServiceCategory] VARCHAR(50) NOT NULL
)

INSERT INTO @serviceCategory
           (ServiceCategoryId, ServiceCategory)
     VALUES
           (1, 'Rawat Jalan')

INSERT INTO [queue].ConstServiceCategory
           ([ServiceCategoryId]
           ,[ServiceCategory])
     SELECT a.ServiceCategoryId
           ,a.ServiceCategory
       FROM @serviceCategory a
            LEFT JOIN [queue].ConstServiceCategory b ON a.ServiceCategoryId = b.ServiceCategoryId
      WHERE b.ServiceCategoryId IS NULL;

/*Seed service type data*/
DECLARE @serviceType TABLE
(
	[ServiceTypeId] TINYINT NOT NULL,
    [TypeId] TINYINT NOT NULL,
    [ServiceCategoryId] TINYINT NOT NULL,
    [ServiceTypeName] VARCHAR(50) NOT NULL, 
    [ServiceTypeCode] VARCHAR(50) NOT NULL
)

INSERT INTO @serviceType
           (ServiceTypeId
           ,TypeId
           ,ServiceCategoryId
           ,ServiceTypeName
           ,ServiceTypeCode)
     VALUES
           (1
           ,1
           ,1
           ,'Pendaftaran Rawat Jalan'
           ,'A'),
           (2
           ,2
           ,1
           ,'Pendaftaran Rawat Jalan'
           ,'B')

INSERT INTO [queue].ConstServiceType
           ([ServiceTypeId]
           ,[TypeId]
           ,[ServiceCategoryId]
           ,[ServiceTypeName]
           ,[ServiceTypeCode])
     SELECT a.ServiceTypeId
           ,a.TypeId
           ,a.ServiceCategoryId
           ,a.ServiceTypeName
           ,a.ServiceTypeCode
       FROM @serviceType a
            LEFT JOIN [queue].ConstServiceType b ON a.ServiceTypeId = b.ServiceTypeId
      WHERE b.ServiceTypeId IS NULL;*/