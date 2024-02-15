USE [AdventureWorks2014]
GO
--Create a new schema named "Items" owned by the user created in tp2
CREATE SCHEMA Items AUTHORIZATION new_user;
GO

--Create a new table "Product" within the "Items" schema
CREATE TABLE Items.Product
(
    ID INT PRIMARY KEY,
    ObjectName NVARCHAR(255),
    ColorName NVARCHAR(255)
);
GO

--2. Edit the new table by adding the following elements:
INSERT INTO Items.Product
    (ID, ObjectName, ColorName)
VALUES
    (1, 'Table', 'Brown'),
    (2, 'Table', 'Black'),
    (3, 'Computer', 'Gold'),
    (4, 'Printer', 'Black'),
    (5, 'Printer', 'Red'),
    (6, 'Bookcase', 'Brown'),
    (7, 'Computer', 'Black'),
    (8, 'Book', 'White'),
    (9, 'Book', 'Green'),
    (10, 'Table', 'Gold');
    GO

-- 3. Create a new clustered index in the table Items.Product. The key column should be Id.
CREATE CLUSTERED INDEX [IX_Product_ID] ON Items.Product
(
[ID] ASC
)
GO

--4.Create a new non-clustered index in the table Items.Product. The key column should be ColorName, and it should INCLUDE ObjectName.
CREATE NONCLUSTERED INDEX [IX_Product_ColorName]
ON Items.Product (ColorName)
INCLUDE (ObjectName);
GO

--5. See how fragmented are the indexes.
SELECT *
FROM
    sys.dm_db_index_physical_stats(DB_ID('AdventureWorks2014'),OBJECT_ID('[Items].[Product]'),NULL,NULL,NULL) AS STATS
    JOIN sys.indexes AS si
    ON stats.object_id=si.object_id
        AND stats.index_id=si.index_id
--V2
-- SELECT
--     OBJECT_NAME(ind.OBJECT_ID) AS TableName,
--     ind.name AS IndexName,
--     indexstats.index_type_desc AS IndexType,
--     indexstats.avg_fragmentation_in_percent AS Fragmentation
-- FROM
--     sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('Adventure.Items.Product'), NULL, NULL, 'DETAILED') indexstats
--     INNER JOIN
--     sys.indexes ind ON ind.object_id = indexstats.object_id AND ind.index_id = indexstats.index_id
-- WHERE 
--     indexstats.avg_fragmentation_in_percent >= 0
--     and
--     OBJECT_NAME(ind.OBJECT_ID)='Product'
-- ORDER BY 
--     indexstats.avg_fragmentation_in_percent DESC;

--6. Reorganize the clustered index.
ALTER INDEX [IX_Product_ID] ON [Items].[Product] REORGANIZE
GO

--7. Change the fill factor of the non-clustered index to 80%.
ALTER INDEX [IX_Product_ColorName] ON [Items].[Product] REBUILD PARTITION =
ALL WITH (FILLFACTOR = 80)
GO

--8. Run multiple queries at the table Items.Product and then identify unused indexes if any.
--Sample Requests:
SELECT *
FROM Items.Product;
UPDATE Items.Product
SET ColorName = 'Silver'
WHERE ObjectName = 'Table';
INSERT INTO Items.Product
    (ID, ObjectName, ColorName)
VALUES
    (11, 'Chair', 'Blue');
Select *
FROM Items.Product
WHERE ObjectName='Table';
Select *
FROM Items.Product
WHERE ColorName='Silver';
Select *
FROM Items.Product
WHERE ObjectName='Computer';
Select *
FROM Items.Product
WHERE ID='3';

SELECT
    o.name AS ObjectName,
    i.name AS IndexName,
    dm_ius.user_seeks,
    dm_ius.user_scans,
    dm_ius.user_lookups,
    dm_ius.user_updates
FROM sys.dm_db_index_usage_stats AS dm_ius
    INNER JOIN sys.indexes AS i ON dm_ius.object_id = i.object_id AND dm_ius.index_id = i.index_id
    INNER JOIN sys.objects AS o ON dm_ius.object_id = o.object_id
WHERE dm_ius.database_id = DB_ID('AdventureWorks2014')
    AND dm_ius.object_id = OBJECT_ID('Items.Product');
    GO

--9. Disable the non-clustered index and then enable it.
ALTER INDEX [IX_Product_ColorName] ON [Items].[Product] DISABLE

ALTER INDEX [IX_Product_ColorName] ON [Items].[Product] REBUILD PARTITION = ALL WITH (FILLFACTOR = 80)
GO

