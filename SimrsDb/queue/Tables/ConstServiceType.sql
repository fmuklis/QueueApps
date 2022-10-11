CREATE TABLE [queue].[ConstServiceType]
(
	[ServiceTypeId] TINYINT NOT NULL PRIMARY KEY,
    [TypeId] TINYINT NOT NULL,
    [ServiceCategoryId] TINYINT NOT NULL,
    [ServiceTypeName] VARCHAR(50) NOT NULL, 
    [ServiceTypeCode] VARCHAR(50) NOT NULL, 
    CONSTRAINT [FK_ConstServiceType_ConstServiceCategory] FOREIGN KEY ([ServiceCategoryId]) REFERENCES [queue].ConstServiceCategory([ServiceCategoryId]), 
    CONSTRAINT [FK_ConstServiceType_ConstType] FOREIGN KEY ([typeid]) REFERENCES [queue].[ConstType]([typeid])
)
