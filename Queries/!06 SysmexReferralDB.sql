CREATE DATABASE SysmexReferralDB;
GO

USE SysmexReferralDB;
GO

CREATE TABLE Department (
depID TINYINT IDENTITY PRIMARY KEY,
depName VARCHAR(30) NOT NULL
);
GO

CREATE TABLE Surgeon (
surgID SMALLINT IDENTITY PRIMARY KEY,
surgName VARCHAR(65) NOT NULL,
depID TINYINT FOREIGN KEY REFERENCES Department(depID) NOT NULL
);
GO

CREATE TABLE Referrer (
refID SMALLINT IDENTITY PRIMARY KEY,
refName VARCHAR(65) NOT NULL,
refType VARCHAR(20) NOT NULL
);
GO

CREATE TABLE Patient (
patNHI VARCHAR(7) PRIMARY KEY NOT NULL,
patName VARCHAR(65) NOT NULL,
patDOB DATE NOT NULL,
patGender VARCHAR(1) NOT NULL
);
GO

CREATE TABLE Referral (
referralID SMALLINT IDENTITY PRIMARY KEY,
refDate DATE NOT NULL,
refID SMALLINT FOREIGN KEY REFERENCES Referrer(refID) NOT NULL,
patNHI VARCHAR(7) FOREIGN KEY REFERENCES Patient(patNHI) NOT NULL,
surgID SMALLINT FOREIGN KEY REFERENCES Surgeon(surgID) NOT NULL,
waitListDate DATE NOT NULL,
FSA DATE,
eligible BIT
);
GO

CREATE TABLE ReferralError (
refErrorID SMALLINT IDENTITY PRIMARY KEY,
refDate DATE,
refID SMALLINT FOREIGN KEY REFERENCES Referrer(refID),
patNHI VARCHAR(7) FOREIGN KEY REFERENCES Patient(patNHI),
surgID SMALLINT FOREIGN KEY REFERENCES Surgeon(surgID),
waitListDate DATE,
FSA DATE,
eligible BIT
);
GO

CREATE TABLE ErrorType (
errorTypeID TINYINT IDENTITY PRIMARY KEY,
errorType VARCHAR(15) NOT NULL
);
GO

CREATE TABLE ReferralError_ErrorType (
errorID SMALLINT IDENTITY PRIMARY KEY,
refErrorID SMALLINT FOREIGN KEY REFERENCES ReferralError(refErrorID) NOT NULL,
errorTypeID TINYINT FOREIGN KEY REFERENCES ErrorType(errorTypeID) NOT NULL,
errorDate SMALLDATETIME NOT NULL
);
GO