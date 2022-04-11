-- For cases when we dont want any dublications in the table instead of having Primary ID key
-- in CSV file we auto generate it with SQL server, its done by creating Staging table without
-- Primary ID key and bulk inserting CSV file to it and then inserting all of the values from
-- Staging table to Main table but only to specific column while ignoring Primary ID Key,
-- therefor autogenerating it with SQL Server.

-- Bulk Inserting to the tables which have no dependent attributes.
-- Since all the Data is already shaped with python, we have nothing to worry about
/*
BULK INSERT Department
FROM 'C:\Users\sever\OneDrive - Ara Institute of Canterbury\_COURSES\DE103 Database Design\DE103-Assessment-1\DATA\! DepartmentID + Department'
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);
GO

BULK INSERT Referrer
FROM 'C:\Users\sever\OneDrive - Ara Institute of Canterbury\_COURSES\DE103 Database Design\DE103-Assessment-1\DATA\! ReferrerID + Referrer + ReferrerType'
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);
GO

BULK INSERT Patient
FROM 'C:\Users\sever\OneDrive - Ara Institute of Canterbury\_COURSES\DE103 Database Design\DE103-Assessment-1\DATA\! NHI + PatientName + DOB + Gender + errorNHI'
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);
GO

-- Creating staging tables for bulk insertion without limitation.
CREATE TABLE Surgeon_Staging (
surgID SMALLINT IDENTITY PRIMARY KEY,
surgName VARCHAR(65) NOT NULL,
depName VARCHAR(30) NOT NULL
);
GO

CREATE TABLE Referral_Staging (
refDate VARCHAR(10) NOT NULL,
refName VARCHAR(65) NOT NULL,
patNHI VARCHAR(7) NOT NULL,
surgName VARCHAR(65) NOT NULL,
waitListDate VARCHAR(10) NOT NULL,
FSA VARCHAR(10),
eligible VARCHAR(3)
);
GO

BULK INSERT Surgeon_Staging
FROM 'C:\Users\sever\OneDrive - Ara Institute of Canterbury\_COURSES\DE103 Database Design\DE103-Assessment-1\DATA\! SurgeonID + Surgeon + Department'
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);
GO

BULK INSERT Referral_Staging
FROM 'C:\Users\sever\OneDrive - Ara Institute of Canterbury\_COURSES\DE103 Database Design\DE103-Assessment-1\DATA\ReferralDate + Referrer + NHI + Surgeon + WaitListDate + FSA + Eligibility.csv'
WITH (
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);
GO

INSERT INTO Surgeon (surgName, depID)
SELECT surgName, depID
FROM Surgeon_Staging S, Department D
WHERE S.depName = D.depName
*/

INSERT INTO Referral (refDate, refID, patNHI, surgID, waitListDate, FSA, eligible)
SELECT refDate, refID, patNHI, surgID, CAST(waitListDate AS DATE), CAST(FSA AS DATE), eligible
FROM Referral_Staging Stg, Referrer R, Surgeon S
WHERE Stg.refName = R.refName
AND Stg.surgName = S.surgName

--SELECT waitListDate FROM Referral_Staging
--SELECT * From Referral
--SELECT * FROM Patient
--SELECT * FROM Surgeon
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

