--? 1. Add a new filegroup called SECONDARY to the database.
USE [AdventureWorksDW2014];
GO

ALTER DATABASE [AdventureWorksDW2014] ADD FILEGROUP [SECONDARY];
GO

--? 2. Change where the table dbo.DimAccount is stored to the SECONDARY filegroup.
EXEC sp_helpindex 'dbo.DimAccount';
GO

ALTER DATABASE [AdventureWorksDW2014] ADD FILE (
	NAME = N'AdventureWorksDW2014',
	FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\AdventureWorksDW2014.ndf',
	SIZE = 8192 KB,
	FILEGROWTH = 65536 KB
	) TO FILEGROUP [SECONDARY];
GO

CREATE UNIQUE CLUSTERED INDEX [PK_DimAccount] ON [dbo].[DimAccount] ([AccountKey] ASC)
	WITH (DROP_EXISTING = ON) ON [SECONDARY];
GO

--? 3. Change where the table dbo DimAccount is stored to the PRIMARY filegroup.
CREATE UNIQUE CLUSTERED INDEX [PK_DimAccount] ON [dbo].[DimAccount] ([AccountKey] ASC)
	WITH (DROP_EXISTING = ON) ON [PRIMARY];
GO

--? 4. Partition the dbo.DimDate table, so that any rows where the FiscalYear is below 2010 goes in the Primary filegroup, and 2010 and later goes in the SECONDARY file group.
SELECT *
FROM [dbo].[DimDate];
GO

EXEC sp_helpindex 'dbo.DimDate';
GO

CREATE PARTITION FUNCTION [DimDatePartitionFunction] (SMALLINT) AS RANGE RIGHT
FOR
VALUES (2010);

CREATE PARTITION SCHEME [DimDatePartitionScheme] AS PARTITION [DimDatePartitionFunction] TO (
	[PRIMARY],
	[SECONDARY]
	);

--* Generated query by SSMS wizard: 
USE [AdventureWorksDW2014]
GO

BEGIN TRANSACTION

ALTER TABLE [dbo].[FactCallCenter]

DROP CONSTRAINT [FK_FactCallCenter_DimDate]

ALTER TABLE [dbo].[FactCurrencyRate]

DROP CONSTRAINT [FK_FactCurrencyRate_DimDate]

ALTER TABLE [dbo].[FactFinance]

DROP CONSTRAINT [FK_FactFinance_DimDate]

ALTER TABLE [dbo].[FactInternetSales]

DROP CONSTRAINT [FK_FactInternetSales_DimDate]

ALTER TABLE [dbo].[FactInternetSales]

DROP CONSTRAINT [FK_FactInternetSales_DimDate1]

ALTER TABLE [dbo].[FactInternetSales]

DROP CONSTRAINT [FK_FactInternetSales_DimDate2]

ALTER TABLE [dbo].[FactProductInventory]

DROP CONSTRAINT [FK_FactProductInventory_DimDate]

ALTER TABLE [dbo].[FactResellerSales]

DROP CONSTRAINT [FK_FactResellerSales_DimDate]

ALTER TABLE [dbo].[FactResellerSales]

DROP CONSTRAINT [FK_FactResellerSales_DimDate1]

ALTER TABLE [dbo].[FactResellerSales]

DROP CONSTRAINT [FK_FactResellerSales_DimDate2]

ALTER TABLE [dbo].[FactSalesQuota]

DROP CONSTRAINT [FK_FactSalesQuota_DimDate]

ALTER TABLE [dbo].[FactSurveyResponse]

DROP CONSTRAINT [FK_FactSurveyResponse_DateKey]

ALTER TABLE [dbo].[DimDate]

DROP CONSTRAINT [PK_DimDate_DateKey]
WITH (ONLINE = OFF)

ALTER TABLE [dbo].[DimDate] ADD CONSTRAINT [PK_DimDate_DateKey] PRIMARY KEY NONCLUSTERED ([DateKey] ASC)
	WITH (
			PAD_INDEX = OFF,
			STATISTICS_NORECOMPUTE = OFF,
			SORT_IN_TEMPDB = OFF,
			IGNORE_DUP_KEY = OFF,
			ONLINE = OFF,
			ALLOW_ROW_LOCKS = ON,
			ALLOW_PAGE_LOCKS = ON,
			OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
			) ON [PRIMARY]

CREATE CLUSTERED INDEX [ClusteredIndex_on_DimDatePartitionScheme_638366185561387667] ON [dbo].[DimDate] ([FiscalYear])
	WITH (
			SORT_IN_TEMPDB = OFF,
			DROP_EXISTING = OFF,
			ONLINE = OFF
			) ON [DimDatePartitionScheme]([FiscalYear])

DROP INDEX [ClusteredIndex_on_DimDatePartitionScheme_638366185561387667] ON [dbo].[DimDate]

ALTER TABLE [dbo].[FactCallCenter]
	WITH CHECK ADD CONSTRAINT [FK_FactCallCenter_DimDate] FOREIGN KEY ([DateKey]) REFERENCES [dbo].[DimDate]([DateKey])

ALTER TABLE [dbo].[FactCallCenter] CHECK CONSTRAINT [FK_FactCallCenter_DimDate]

ALTER TABLE [dbo].[FactCurrencyRate]
	WITH CHECK ADD CONSTRAINT [FK_FactCurrencyRate_DimDate] FOREIGN KEY ([DateKey]) REFERENCES [dbo].[DimDate]([DateKey])

ALTER TABLE [dbo].[FactCurrencyRate] CHECK CONSTRAINT [FK_FactCurrencyRate_DimDate]

ALTER TABLE [dbo].[FactFinance]
	WITH CHECK ADD CONSTRAINT [FK_FactFinance_DimDate] FOREIGN KEY ([DateKey]) REFERENCES [dbo].[DimDate]([DateKey])

ALTER TABLE [dbo].[FactFinance] CHECK CONSTRAINT [FK_FactFinance_DimDate]

ALTER TABLE [dbo].[FactInternetSales]
	WITH CHECK ADD CONSTRAINT [FK_FactInternetSales_DimDate] FOREIGN KEY ([OrderDateKey]) REFERENCES [dbo].[DimDate]([DateKey])

ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimDate]

ALTER TABLE [dbo].[FactInternetSales]
	WITH CHECK ADD CONSTRAINT [FK_FactInternetSales_DimDate1] FOREIGN KEY ([DueDateKey]) REFERENCES [dbo].[DimDate]([DateKey])

ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimDate1]

ALTER TABLE [dbo].[FactInternetSales]
	WITH CHECK ADD CONSTRAINT [FK_FactInternetSales_DimDate2] FOREIGN KEY ([ShipDateKey]) REFERENCES [dbo].[DimDate]([DateKey])

ALTER TABLE [dbo].[FactInternetSales] CHECK CONSTRAINT [FK_FactInternetSales_DimDate2]

ALTER TABLE [dbo].[FactProductInventory]
	WITH CHECK ADD CONSTRAINT [FK_FactProductInventory_DimDate] FOREIGN KEY ([DateKey]) REFERENCES [dbo].[DimDate]([DateKey])

ALTER TABLE [dbo].[FactProductInventory] CHECK CONSTRAINT [FK_FactProductInventory_DimDate]

ALTER TABLE [dbo].[FactResellerSales]
	WITH CHECK ADD CONSTRAINT [FK_FactResellerSales_DimDate] FOREIGN KEY ([OrderDateKey]) REFERENCES [dbo].[DimDate]([DateKey])

ALTER TABLE [dbo].[FactResellerSales] CHECK CONSTRAINT [FK_FactResellerSales_DimDate]

ALTER TABLE [dbo].[FactResellerSales]
	WITH CHECK ADD CONSTRAINT [FK_FactResellerSales_DimDate1] FOREIGN KEY ([DueDateKey]) REFERENCES [dbo].[DimDate]([DateKey])

ALTER TABLE [dbo].[FactResellerSales] CHECK CONSTRAINT [FK_FactResellerSales_DimDate1]

ALTER TABLE [dbo].[FactResellerSales]
	WITH CHECK ADD CONSTRAINT [FK_FactResellerSales_DimDate2] FOREIGN KEY ([ShipDateKey]) REFERENCES [dbo].[DimDate]([DateKey])

ALTER TABLE [dbo].[FactResellerSales] CHECK CONSTRAINT [FK_FactResellerSales_DimDate2]

ALTER TABLE [dbo].[FactSalesQuota]
	WITH CHECK ADD CONSTRAINT [FK_FactSalesQuota_DimDate] FOREIGN KEY ([DateKey]) REFERENCES [dbo].[DimDate]([DateKey])

ALTER TABLE [dbo].[FactSalesQuota] CHECK CONSTRAINT [FK_FactSalesQuota_DimDate]

ALTER TABLE [dbo].[FactSurveyResponse]
	WITH CHECK ADD CONSTRAINT [FK_FactSurveyResponse_DateKey] FOREIGN KEY ([DateKey]) REFERENCES [dbo].[DimDate]([DateKey])

ALTER TABLE [dbo].[FactSurveyResponse] CHECK CONSTRAINT [FK_FactSurveyResponse_DateKey]

COMMIT TRANSACTION

SELECT *,
	$PARTITION.DimDatePartitionFunction(FiscalYear) AS PartitionNumber
FROM [dbo].[DimDate]

--? 5. Apply Page Compression to dbo.FactInternetSales.
EXEC sp_estimate_data_compression_savings [dbo],
	[FactInternetSales],
	1,
	NULL,
	'PAGE'

ALTER TABLE dbo.FactInternetSales REBUILD
	WITH (DATA_COMPRESSION = PAGE);
GO


