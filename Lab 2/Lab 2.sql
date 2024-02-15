USE AdventureWorks2014;
GO

CREATE ROLE DenyHRDepartment;
GO

DENY SELECT ON OBJECT::HumanResources.Department TO DenyHRDepartment;
GO

USE AdventureWorks2014;
GO
CREATE USER new_user FOR LOGIN "LEGION5\AzizTP" WITH DEFAULT_SCHEMA = dbo;
GO

USE AdventureWorks2014;
GO
ALTER ROLE DenyHRDepartment ADD MEMBER new_user;
GO

USE AdventureWorks2014;
GO
CREATE ROLE GrantHRDepartmentEmployee;
GO

GRANT SELECT ON HumanResources.Employee TO GrantHRDepartmentEmployee;

GRANT SELECT ON HumanResources.Department TO GrantHRDepartmentEmployee;

GO
ALTER ROLE GrantHRDepartmentEmployee ADD MEMBER new_user;
GO

USE [AdventureWorks2014]
GO
SELECT *
FROM HumanResources.Employee

USE [AdventureWorks2014]
GO
SELECT *
FROM HumanResources.Department