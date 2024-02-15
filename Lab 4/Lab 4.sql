USE [AdventureWorks2014]
GO

Delete FROM [HumanResources].Department WHERE DepartmentID = 17;
GO

SELECT count(*)
FROM [HumanResources].[Department]
GO


--! Doesn't work
SELECT 1 / 0
GO

--* Work fine
BEGIN TRY
    SELECT 1 / 0;
END TRY
BEGIN CATCH
    RAISERROR('Division by zero error occurred.', 16, 1) WITH LOG;
END CATCH;

RAISERROR (50001, 16, 1) WITH LOG
GO