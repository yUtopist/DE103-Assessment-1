--
-- This query will give a list of all patients that have been referred for Cardiothoracic.
-- At the bottom, commented out, simplified version of the list.

--
-- If this is the first query to run, we need to use the correct Database with this command
-- USE SysmexReferralDB;

SELECT
	-- Date Information
	FORMAT(refDate, 'dd/MM/yyyy') AS 'Referral Date'
,	FORMAT(refDate, 'yyyy-M') AS 'Year-Month'
	-- Referrer
,	(SELECT refName FROM Referrer t WHERE t.refID = m.refID) AS 'Referred By'
,	(SELECT refType FROM Referrer t WHERE t.refID = m.refID) AS 'Referred From'
	-- Patient
,	patNHI AS 'NHI'
,	(SELECT patName FROM Patient t WHERE t.patNHI = m.patNHI) AS 'Patient Name'
,	CASE
		WHEN (SELECT patGender FROM Patient t WHERE t.patNHI = m.patNHI) = 'M' THEN 'Male'
		WHEN (SELECT patGender FROM Patient t WHERE t.patNHI = m.patNHI) = 'F' THEN 'Female'
		WHEN (SELECT patGender FROM Patient t WHERE t.patNHI = m.patNHI) = 'O' THEN 'Other'	END AS 'Gender'
,	FORMAT((SELECT patDOB FROM Patient t WHERE t.patNHI = m.patNHI), 'dd/MM/yyyy') AS 'DOB'
,	DATEDIFF(year, (SELECT patDOB FROM Patient t WHERE t.patNHI = m.patNHI), refDate) AS 'Age at Referral'
	-- Surgeon
,	(SELECT surgName FROM Surgeon t WHERE m.surgID = t.surgID) AS 'Surgeon'
,	(SELECT depName	FROM Surgeon t INNER JOIN Department d ON t.depID = d.depID	WHERE m.surgID = t.surgID) AS 'Department'
	-- Technicalities
,	FORMAT(waitListDate, 'dd/MM/yyyy') AS 'Added to Waitlist Date'
,	FORMAT(FSA, 'dd/MM/yyyy') AS 'FSA Date'
,	DATEDIFF(day, refDate, FSA) AS 'Days Waited'
,	CASE
		WHEN eligible = '1' THEN 'Yes'
		WHEN eligible = '0' THEN 'No' END AS 'Health Target Eligible'
FROM Referral m
WHERE (SELECT depName	FROM Surgeon t INNER JOIN Department d ON t.depID = d.depID	WHERE m.surgID = t.surgID) = 'Cardiothoracic'
AND eligible = 1
ORDER BY refDate

/*
SELECT
	-- Date Information
	FORMAT(refDate, 'dd/MM/yyyy') AS 'Referral Date'
	-- Patient
,	patNHI AS 'NHI'
,	(SELECT patName FROM Patient t WHERE t.patNHI = m.patNHI) AS 'Patient Name'
,	CASE
		WHEN (SELECT patGender FROM Patient t WHERE t.patNHI = m.patNHI) = 'M' THEN 'Male'
		WHEN (SELECT patGender FROM Patient t WHERE t.patNHI = m.patNHI) = 'F' THEN 'Female'
		WHEN (SELECT patGender FROM Patient t WHERE t.patNHI = m.patNHI) = 'O' THEN 'Other'	END AS 'Gender'
,	DATEDIFF(year, (SELECT patDOB FROM Patient t WHERE t.patNHI = m.patNHI), refDate) AS 'Age at Referral'
	-- Surgeon
,	(SELECT surgName FROM Surgeon t WHERE m.surgID = t.surgID) AS 'Surgeon'
,	(SELECT depName	FROM Surgeon t INNER JOIN Department d ON t.depID = d.depID	WHERE m.surgID = t.surgID) AS 'Department'
	-- Technicalities
,	FORMAT(waitListDate, 'dd/MM/yyyy') AS 'Added to Waitlist Date'
,	FORMAT(FSA, 'dd/MM/yyyy') AS 'FSA Date'
,	DATEDIFF(day, refDate, FSA) AS 'Days Waited'
FROM Referral m
WHERE (SELECT depName	FROM Surgeon t INNER JOIN Department d ON t.depID = d.depID	WHERE m.surgID = t.surgID) = 'Cardiothoracic'
AND eligible = 1
ORDER BY refDate
*/