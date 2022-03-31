USE SysmexReferralDB;
GO

CREATE TABLE ReferrerType (
refTypeID TINYINT PRIMARY KEY,
refType VARCHAR(20)
);
GO

ALTER TABLE Referrer
DROP COLUMN refType;
GO

ALTER TABLE Referrer
ADD refTypeID TINYINT FOREIGN KEY REFERENCES ReferrerType(refTypeID)
GO