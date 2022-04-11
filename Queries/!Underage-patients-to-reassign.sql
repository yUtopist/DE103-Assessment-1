-- This query will give a list of all patients under 18 at the time of referral and having sugeon assigned from any other than paediatric department

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
,	FORMAT((SELECT patDOB FROM Patient t WHERE t.patNHI = m.patNHI), 'dd/MM/yyyy') AS 'DOB'
,	DATEDIFF(year, (SELECT patDOB FROM Patient t WHERE t.patNHI = m.patNHI), refDate) AS 'Age at Referral'
	-- Surgeon
,	(SELECT surgName FROM Surgeon t WHERE m.surgID = t.surgID) AS 'Surgeon'
,	(SELECT depName	FROM Surgeon t INNER JOIN Department d ON t.depID = d.depID	WHERE m.surgID = t.surgID) AS 'Department'
	-- Technicalities
,	FORMAT(waitListDate, 'dd/MM/yyyy') AS 'Added to Waitlist Date'
,	FORMAT(FSA, 'dd/MM/yyyy') AS 'FSA Date'
,	CASE
		WHEN eligible = '1' THEN 'Yes'
		WHEN eligible = '0' THEN 'No' END AS 'Health Target Eligible'
FROM Referral m
WHERE DATEDIFF(year, (SELECT patDOB FROM Patient t WHERE t.patNHI = m.patNHI), refDate) < 18
AND (SELECT depName	FROM Surgeon t INNER JOIN Department d ON t.depID = d.depID	WHERE m.surgID = t.surgID) != 'Paediatric Surgery'
AND eligible = 1
ORDER BY 'Age at Referral'