-- For cases when we dont want any dublications in the table instead of having Primary ID key
-- in CSV file we auto generate it with SQL server, its done by creating Staging table without
-- Primary ID key and bulk inserting CSV file to it and then inserting all of the values from
-- Staging table to Main table but only to specific column while ignoring Primary ID Key,
-- therefor autogenerating it with SQL Server.

/*
CREATE TABLE Department_Staging (
depName VARCHAR(255) NOT NULL
);
GO

BULK INSERT Department_Staging
FROM 'C:\Users\sever\OneDrive - Ara Institute of Canterbury\_COURSES\DE103 Database Design\DE103-Assessment-1\DATA\Department.csv'
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);
GO

INSERT INTO Department (depName)
SELECT DISTINCT depName
FROM Department_Staging Staging
WHERE NOT EXISTS (
SELECT *
FROM Department AS Main
WHERE Main.depName = Staging.depName
)
GO

-- Deleting Temp Table
DROP TABLE Department_Staging
GO

CREATE TABLE Surgeon_Staging (
surgName VARCHAR(255) NOT NULL,
depName VARCHAR(255) NOT NULL
);
GO

BULK INSERT Surgeon_Staging
FROM 'C:\Users\sever\OneDrive - Ara Institute of Canterbury\_COURSES\DE103 Database Design\DE103-Assessment-1\DATA\Surgeon + Department.csv'
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);
GO

INSERT INTO Surgeon (surgName, depID) 
SELECT DISTINCT surgName, depID
FROM Surgeon_Staging Staging, Department
WHERE NOT EXISTS (
SELECT *
FROM Surgeon AS Main
WHERE Main.surgName = Staging.surgName
)
AND Department.depName = Staging.depName

-- Deleting Temp Table
DROP TABLE Surgeon_Staging
GO

CREATE TABLE Referrer_Staging (
refName VARCHAR(255) NOT NULL,
refType VARCHAR(255) NOT NULL
);
GO

BULK INSERT Referrer_Staging
FROM 'C:\Users\sever\OneDrive - Ara Institute of Canterbury\_COURSES\DE103 Database Design\DE103-Assessment-1\DATA\Referrer + ReferrerType.csv'
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);
GO

*/
/*

INSERT INTO Referrer (refName, refType)
SELECT DISTINCT refName, refType
FROM Referrer_Staging Staging
WHERE NOT EXISTS (
SELECT *
FROM Referrer AS Main
WHERE Main.refName = Staging.refName
)

GO

*/

--DELETE FROM Referrer
SELECT * FROM Referrer


/*
-- WORKING Example of String separation
SELECT
surgName,
SUBSTRING(A.surgName, 0, CHARINDEX(' ', A.surgName, 0)) AS 'First Name',
SUBSTRING(A.surgName, CHARINDEX(' ', A.surgName, 0) + 1, LEN(A.surgName)) AS 'Last Name',
B.depID
FROM Surgeon_Staging A, Department B
WHERE A.depName = B.depName
*/

